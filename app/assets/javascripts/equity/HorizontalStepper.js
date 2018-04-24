import React from 'react';

function Circle({text, color, style = {}}) {
  return <div style={{display: 'inline-block', ...style}} dangerouslySetInnerHTML={{__html: `<svg viewBox="0 0 24 24" style="display: inline-block; color: ${color}; fill: ${color}; height: 24px; width: 24px; user-select: none; transition: all 450ms cubic-bezier(0.23, 1, 0.32, 1) 0ms; font-size: 24px;"><circle cx="12" cy="12" r="10"></circle><text x="12" y="16" text-anchor="middle" font-size="12" fill="#fff">${text}</text></svg>`}} />;
}
Circle.propTypes = {
  text: React.PropTypes.string.isRequired,
  style: React.PropTypes.object
};



export default class HorizontalStepper extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      currentStepIndex: props.defaultStepIndex || 0
    };

    this.onStepClicked = this.onStepClicked.bind(this);
    this.onPreviousClicked = this.onPreviousClicked.bind(this);
    this.onNextClicked = this.onNextClicked.bind(this);
  }

  onStepClicked(stepIndex) {
    this.setState({currentStepIndex: stepIndex});
  }

  onPreviousClicked() {
    const {currentStepIndex} = this.state;
    this.setState({currentStepIndex: currentStepIndex - 1});
  }

  onNextClicked() {
    const {currentStepIndex} = this.state;
    this.setState({currentStepIndex: currentStepIndex + 1});
  }

  render() {
    const {steps, renderFn, style} = this.props;
    const {currentStepIndex} = this.state;
    return (
      <div className="HorizontalStepper" style={style}>
        <div style={styles.banner}>
          {steps.map((step, stepIndex) => {
            return (
              <span
                key={stepIndex}
                style={this.renderStyleForBannerItem(stepIndex, currentStepIndex)}
                onClick={this.onStepClicked.bind(this, stepIndex)}>
                <Circle
                  text={`${stepIndex+1}`}
                  color={this.renderColorForCircle(stepIndex, currentStepIndex)}
                  style={{verticalAlign: 'middle'}}/>
                <span style={styles.bannerText}>{step}</span>
              </span>
            );
          })}
        </div>
        <div>{renderFn(currentStepIndex, steps[currentStepIndex])}</div>
        {this.renderNavigationButtons()}
      </div>
    );
  }

  renderColorForCircle(index, currentIndex) {
    return (index <= currentIndex)
      ? '#3177c9'
      : '#ccc';
  }

  renderStyleForBannerItem(index, currentIndex) {
    if (index === currentIndex) return {...styles.bannerItem, borderBottom: '2px solid #3177c9' };
    return (index <= currentIndex)
      ? styles.bannerItem
      : {...styles.bannerItem, color: '#ccc' };
  }

  renderNavigationButtons() {
    const {steps} = this.props;
    const {currentStepIndex} = this.state;
    const shouldShowNext = (currentStepIndex < steps.length - 1);
    const shouldShowPrevious = (currentStepIndex > 0);
    return (
      <div>
        {shouldShowPrevious && <button className="btn" style={{float: 'left', marginLeft: 10, marginTop: 10}} onClick={this.onPreviousClicked}>{`< Back `}</button>}
        {shouldShowNext && <button className="btn" style={{float: 'right', marginRight: 10, marginTop: 10}} onClick={this.onNextClicked}>Next ></button>}
      </div>
    );
  }
}
HorizontalStepper.propTypes = {
  steps: React.PropTypes.array.isRequired,
  renderFn: React.PropTypes.func.isRequired,
  defaultStepIndex: React.PropTypes.number,
  style: React.PropTypes.object
};

const styles = {
  banner:{
    fontSize: 12
  },
  bannerItem: {
    padding: 5,
    paddingLeft: 0,
    marginLeft: 5,
    marginRight: 10,
    cursor: 'pointer'
  },
  bannerText: {
    paddingLeft: 5
  },
  check: {},
  divider: {
    width: '2em',
    height: 1,
    borderTop: '1px solid #eee'
  }
};