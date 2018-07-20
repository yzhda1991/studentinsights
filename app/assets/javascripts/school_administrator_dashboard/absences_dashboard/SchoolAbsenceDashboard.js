import React from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';
import moment from 'moment';
import {supportsExcusedAbsences} from '../../helpers/PerDistrict';
import SectionHeading from '../../components/SectionHeading';
import DashboardHelpers from '../DashboardHelpers';
import StudentsTable from '../StudentsTable';
import DashboardBarChart from '../DashboardBarChart';
import DashRangeButtons from '../DashRangeButtons';
import DashButton from '../DashButton';


export default class SchoolAbsenceDashboard extends React.Component {

  constructor(props, context) {
    super(props);

    const {dateRange} = props;
    const {districtKey, nowFn} = context;
    const showExcused = supportsExcusedAbsences(districtKey) ? false : true;
    const {displayDates, selectedRange} = initialTimeRange(nowFn(), dateRange);
    this.state = {
      showExcused,
      displayDates,
      selectedRange,
      selectedHomeroom: null,
    };
    this.setStudentList = (highchartsEvent) => {
      this.setState({selectedHomeroom: highchartsEvent.point.category});
    };
    this.resetStudentList = () => {
      this.setState({selectedHomeroom: null});
    };
  }

  //Monthly attendance for the school must be calculated after the range filter is applied
  monthlySchoolAttendance(schoolAverageDailyAttendance) {
    let monthlySchoolAttendance = {};
    //Use the filtered daterange to find the days to include
    this.state.displayDates.forEach((day) => {
      const date = moment.utc(day).date(1).format("YYYY-MM"); //first day of the month in which 'day' occurs
      if (schoolAverageDailyAttendance[day] !== undefined) { //school days are based on all absences so it's possible this is undefined when getting the total for unexcused absences
        (monthlySchoolAttendance[date] === undefined) ? //if there's nothing for this month yet
        monthlySchoolAttendance[date] = [schoolAverageDailyAttendance[day]] :
        monthlySchoolAttendance[date] = monthlySchoolAttendance[date].concat(schoolAverageDailyAttendance[day]);
      }
    });
    return monthlySchoolAttendance;
  }

  monthlyHomeroomAttendance(dailyHomeroomAttendance) {
    let monthlyHomeroomAttendance = {};
    Object.keys(dailyHomeroomAttendance).forEach((homeroom) => {
      const rawAvg = _.sum(dailyHomeroomAttendance[homeroom])/dailyHomeroomAttendance[homeroom].length;
      const monthlyAverage = Math.round(rawAvg*10)/10;
      monthlyHomeroomAttendance[homeroom] = monthlyAverage;
    });

    return monthlyHomeroomAttendance;
  }

  filteredHomeroomAttendance(dailyHomeroomAttendance) {
    let filteredHomeroomAttendance = {};
    Object.keys(dailyHomeroomAttendance).forEach((homeroom) => {
      filteredHomeroomAttendance[homeroom] = this.state.displayDates.map((date) => {
        return dailyHomeroomAttendance[homeroom][date];
      });
    });
    return filteredHomeroomAttendance;
  }

  studentAbsenceCounts() {
    let studentAbsenceCounts = {};
    const eventsByDay = this.state.showExcused ? this.props.schoolAbsenceEventsByDay : this.props.schoolUnexcusedAbsenceEventsByDay;
    this.state.displayDates.forEach((day) => {
      _.each(eventsByDay[day], (absence) => {
        studentAbsenceCounts[absence.student_id] = studentAbsenceCounts[absence.student_id] || 0;
        studentAbsenceCounts[absence.student_id]++;
      });
    });
    return studentAbsenceCounts;
  }

  render() {
    const {school} = this.props;
    return (
      <div className="SchoolAbsenceDashboard" style={styles.root}>
        <SectionHeading>Absences at {school.name}</SectionHeading>
        <div className="SchoolDashboard-filter-bar">
          {this.renderRangeSelector()}
          {this.renderExcusedAbsencesSelect()}
        </div>
        <div className="SchoolDashboard-columns">
          <div className="SchoolDashboard-roster-column">
            {this.renderStudentAbsenceTable()}
          </div>
          <div className="SchoolDashboard-charts-column">
            {this.renderMonthlyAbsenceChart()}
            {this.renderHomeroomAbsenceChart()}
          </div>
        </div>
      </div>
    );
  }

  renderRangeSelector() {
    const {dateRange} = this.props;
    const {nowFn} = this.context;
    const now = nowFn();
    const today = now.format("YYYY-MM-DD");
    const ninetyDaysAgo = now.clone().subtract(90, 'days').format("YYYY-MM-DD");
    const fortyFiveDaysAgo = now.clone().subtract(45, 'days').format("YYYY-MM-DD");
    const schoolYearStart = DashboardHelpers.schoolYearStart();
    const {defaultSelectedButton} = initialTimeRange(now, dateRange);
    return (
      <DashRangeButtons
        defaultSelectedButton={defaultSelectedButton}
        schoolYearFilter={() => this.setState({
          displayDates: DashboardHelpers.filterDates(dateRange, schoolYearStart, today),
          selectedRange: 'School Year'})}
        ninetyDayFilter={() => this.setState({
          displayDates: DashboardHelpers.filterDates(dateRange, ninetyDaysAgo, today),
          selectedRange: 'Last 90 Days'})}
        fortyFiveDayFilter={() => this.setState({
          displayDates: DashboardHelpers.filterDates(dateRange, fortyFiveDaysAgo, today),
          selectedRange: 'Last 45 Days'})}/>
    );
  }

  renderStudentAbsenceTable() {
    const studentAbsenceCounts = this.studentAbsenceCounts();
    const studentsByHomeroom = DashboardHelpers.groupByHomeroom(this.props.dashboardStudents);
    const students = studentsByHomeroom[this.state.selectedHomeroom] || this.props.dashboardStudents;
    let rows =[];
    students.forEach((student) => {
      rows.push({
        id: student.id,
        first_name: student.first_name,
        last_name: student.last_name,
        latest_note: student.latest_note,
        events: studentAbsenceCounts[student.id] || 0,
        grade: student.grade,
      });
    });

    const {selectedRange} = this.state;

    return (
      <StudentsTable
        rows={rows}
        selectedCategory={this.state.selectedHomeroom}
        incidentType='Absences'
        incidentSubtitle={selectedRange}
        resetFn={this.resetStudentList}/>
    );
  }

  renderExcusedAbsencesSelect() {
    const {districtKey} = this.context;
    if (!supportsExcusedAbsences(districtKey)) return null;

    return(
      <div style={styles.excusedFilter} className="SchoolAbsenceDashboard-excused-absences-select">
        <DashButton
            buttonText={"Unexcused Absences Only"}
            onClick={() => this.setState({showExcused: false})}
            isSelected={!this.state.showExcused}/>
        <DashButton
          buttonText={"All Absences"}
          onClick={() => this.setState({showExcused: true})}
          isSelected={this.state.showExcused}/>
      </div>
    );
  }

  renderMonthlyAbsenceChart() {
    const dailyAttendance = this.state.showExcused ?
                            this.props.schoolAverageDailyAttendance :
                            this.props.schoolAverageDailyAttendanceUnexcused;
    const monthlyAttendance = this.monthlySchoolAttendance(dailyAttendance);
    const filteredAttendanceSeries = Object.keys(monthlyAttendance).map( (month) => {
      const rawAvg = _.sum(monthlyAttendance[month])/monthlyAttendance[month].length;
      return Math.round(rawAvg*10)/10;
    });
    const categories = Object.keys(monthlyAttendance);

    return (
        <DashboardBarChart
          id = {'string'}
          categories = {{categories: categories}}
          seriesData = {filteredAttendanceSeries}
          yAxisMin = {80}
          yAxisMax = {100}
          titleText = {`Average Attendance By Month (${this.state.selectedRange})`}
          measureText = {'Attendance (Percent)'}
          tooltip = {{
            pointFormat: 'Average Daily Attendance: <b>{point.y}</b>',
            valueSuffix: '%'}}
          onColumnClick = {this.resetStudentList}
          onBackgroundClick = {this.resetStudentList}/>
    );
  }

  renderHomeroomAbsenceChart() {
    const homeroomAverageDailyAttendance =  this.state.showExcused ?
                                            this.props.homeroomAverageDailyAttendance :
                                            this.props.homeroomAverageDailyAttendanceUnexcused;
    const filteredHomeroomAttendance = this.filteredHomeroomAttendance(homeroomAverageDailyAttendance); //remove dates outside of selected range
    const monthlyHomeroomAttendance = this.monthlyHomeroomAttendance(filteredHomeroomAttendance); //Average homeroom attendance by month
    const homerooms = Object.keys(monthlyHomeroomAttendance).sort((a,b) => { //sort homerooms by attendance, low to high
      return monthlyHomeroomAttendance[a] - monthlyHomeroomAttendance[b];
    });
    const homeroomSeries = homerooms.map((homeroom) => {
      return monthlyHomeroomAttendance[homeroom];
    });

    return (
      <DashboardBarChart
        id = {'string'}
        categories = {{categories: homerooms}}
        seriesData = {homeroomSeries}
        yAxisMin = {80}
        yAxisMax = {100}
        titleText = {`Average Attendance By Homeroom (${this.state.selectedRange})`}
        measureText = {'Attendance (Percent)'}
        tooltip = {{
          pointFormat: 'Average Daily Attendance: <b>{point.y}</b>',
          valueSuffix: '%'}}
        onColumnClick = {this.setStudentList}
        onBackgroundClick = {this.resetStudentList}/>
    );
  }
}
SchoolAbsenceDashboard.contextTypes = {
  nowFn: PropTypes.func.isRequired,
  districtKey: PropTypes.string.isRequired
};
SchoolAbsenceDashboard.propTypes = {
  schoolAverageDailyAttendance: PropTypes.object.isRequired,
  schoolAverageDailyAttendanceUnexcused: PropTypes.object.isRequired,
  homeroomAverageDailyAttendance: PropTypes.object.isRequired,
  homeroomAverageDailyAttendanceUnexcused: PropTypes.object.isRequired,
  dashboardStudents: PropTypes.array.isRequired,
  schoolAbsenceEventsByDay: PropTypes.object.isRequired,
  schoolUnexcusedAbsenceEventsByDay: PropTypes.object.isRequired,
  dateRange: PropTypes.array.isRequired,
  school: PropTypes.shape({
    name: PropTypes.string.isRequired
  }).isRequired
};

const styles = {
  root: {
    flex: 1,
    width: '100%',
    paddingLeft: 10,
    paddingRight: 10,
    display: 'flex',
    flexDirection: 'column'
  },
  excusedFilter: {
    display: 'flex',
    alignItems: 'flex-end',
    paddingLeft: 20,
    marginLeft: 20,
    borderLeft: 'thin solid #ccc'
  }
};


// Set this to 45 days ago, and describe this in the different formats the component
// expects.
function initialTimeRange(now, dateRange) {
  const today = now.format("YYYY-MM-DD");
  const fortyFiveDaysAgo = now.clone().subtract(45, 'days').format("YYYY-MM-DD");
  const displayDates = DashboardHelpers.filterDates(dateRange, fortyFiveDaysAgo, today);
  const defaultSelectedButton = 'fortyFiveDays';
  const selectedRange = 'Last 45 Days';

  return {displayDates, selectedRange, defaultSelectedButton};
}