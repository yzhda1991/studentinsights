import React from 'react';
import FeedCardFrame from './FeedCardFrame';
import HouseBadge from '../components/HouseBadge';
import Badge from '../components/Badge';
import Timestamp from '../components/Timestamp';


// Render a card in the feed for a discipline incident
class IncidentCard extends React.Component {
  render() {
    const {style, incidentCard} = this.props;
    const {student} = incidentCard;

    return (
      <div className="IncidentCard" >
        <FeedCardFrame
          style={style}
          student={student}
          whereEl={<div>in {incidentCard.incident_location}</div>}
          whenEl={<Timestamp railsTimestamp={incidentCard.occurred_at} />}
          badgesEl={<div>
            {student.house && <HouseBadge style={styles.footerBadge} house={student.house} />}
            <Badge style={styles.footerBadge} text="Incident" backgroundColor="rgb(255, 140, 0)" />
          </div>}
        >
          <div>{incidentCard.incident_description} (code: {incidentCard.incident_code})</div>
        </FeedCardFrame>
      </div>
    );
  }
}
IncidentCard.propTypes = {
  incidentCard: React.PropTypes.shape({
    id: React.PropTypes.number.isRequired,
    incident_code: React.PropTypes.string.isRequired,
    incident_location: React.PropTypes.string.isRequired,
    incident_description: React.PropTypes.string.isRequired,
    occurred_at: React.PropTypes.string.isRequired,
    has_exact_time: React.PropTypes.bool.isRequired,
    student: React.PropTypes.shape({
      id: React.PropTypes.number.isRequired,
      first_name: React.PropTypes.string.isRequired,
      last_name: React.PropTypes.string.isRequired,
      grade: React.PropTypes.string.isRequired,
      house: React.PropTypes.string,
      homeroom: React.PropTypes.shape({
        id: React.PropTypes.number.isRequired,
        name: React.PropTypes.string.isRequired,
        educator: React.PropTypes.object
      })
    })
  }),
  style: React.PropTypes.object
};


const styles = {
  footerBadge: {
    marginLeft: 5
  }
};

export default IncidentCard;