import React from 'react';
import PropTypes from 'prop-types';
import SectionHeading from '../components/SectionHeading';
const styles = {
  textarea: {
    marginTop: 20,
    fontSize: 14,
    border: '1px solid #eee',
    width: '100%' //overriding strange global CSS, should cleanup
  }
};

const notePrompts = `What are this student's strengths?
——————————


What is this student's involvement in the school community like?
——————————


How does this student relate to their peers?
——————————


Any additional comments or good things to know about this student?
——————————


`;

const restrictedNotePrompts = `Is this student receiving Social Services and if so, what is the name and contact info of their social worker?
——————————


Is this student receiving mental health supports?
——————————
  `;

class TransitionNotes extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      noteText: notePrompts,
      restrictedNoteText: restrictedNotePrompts,
    };

    this.onClickSave = this.onClickSave.bind(this);
    this.onClickSaveRestricted = this.onClickSaveRestricted.bind(this);
  }

  onClickSave() {
    this.props.onSave({text: this.state.noteText});
  }

  onClickSaveRestricted() {
    this.props.onSave({text: this.state.restrictedNoteText});
  }

  render() {
    const {noteText, restrictedNoteText} = this.state;

    return (
      <div style={{display: 'flex'}}>
        <div style={{flex: 1, margin: 30}}>
          <SectionHeading>
            High School Transition Note
          </SectionHeading>
          <textarea
            rows={10}
            style={styles.textarea}
            value={noteText}
            onChange={(e) => this.setState({noteText: e.target.value})} />
          <button onClick={this.onClickSave} className="btn save">
            Save note
          </button>
        </div>
        <div style={{flex: 1, margin: 30}}>
          <SectionHeading>
            High School Transition Note (Restricted)
          </SectionHeading>
          <textarea
            rows={10}
            style={styles.textarea}
            value={restrictedNoteText}
            onChange={(e) => this.setState({restrictedNoteText: e.target.value})}/>
          <button onClick={this.onClickSaveRestricted} className="btn save">
            Save note
          </button>
        </div>
      </div>
    );
  }

}

TransitionNotes.propTypes = {
  readOnly: PropTypes.bool.isRequired,
  onSave: PropTypes.func.isRequired,
};

export default TransitionNotes;

