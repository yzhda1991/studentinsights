import React from 'react';
import moment from 'moment';
import { shallow } from 'enzyme';

import SchoolDisciplineDashboard from '../../../app/assets/javascripts/school_administrator_dashboard/dashboard_components/discipline_dashboard/SchoolDisciplineDashboard';
import { createStudents } from './DashboardTestData';

describe('SchoolDisciplineDashboard', () => {
  const dash = shallow(<SchoolDisciplineDashboard
                        dashboardStudents={createStudents(moment.utc())}
                        schoolDisciplineEvents={[]}/>);

  it('renders at least one bar chart', () => {
    expect(dash.find('DashboardBarChart').length > 0).toEqual(true);
  });

  it('renders a student list', () => {
    expect(dash.find('StudentsTable').length).toEqual(1);
  });

  it('renders a date range selector', () => {
    expect(dash.find('DashRangeButtons').length).toEqual(1);
  });
});
