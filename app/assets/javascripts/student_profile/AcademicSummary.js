import React from 'react';
import PropTypes from 'prop-types';

const  styles = {
  caption: {
    marginRight: 5
  },
  value: {
    fontWeight: 'bold'
  },
  sparklineContainer: {
    paddingLeft: 15,
    paddingRight: 15
  },
  textContainer: {
    paddingBottom: 5
  }
};

class AcademicSummary extends React.Component {

  constructor(props) {
    super(props); 
  }

  render() {
    return (
      <div className="AcademicSummary">
        <div style={styles.textContainer}>
          <span style={styles.caption}>
            {this.props.caption + ':'}
          </span>
          <span style={styles.value}>
            {(this.props.value === undefined) ? 'none' : this.props.value}
          </span>
        </div>
        <div style={styles.sparklineContainer}>
          {this.props.sparkline}
        </div>
      </div>
    );
  }
}

AcademicSummary.propTypes = {
  caption: PropTypes.string.isRequired,
  sparkline: PropTypes.element.isRequired,
  value: PropTypes.number // value or null
};



export default AcademicSummary;

