import React from 'react';
import ReactDOM from 'react-dom';
import {
  nowMoment,
  currentEducator
} from './fixtures/fixtures';
import {SOMERVILLE, NEW_BEDFORD, BEDFORD} from '../helpers/PerDistrict';
import PerDistrictContainer from '../components/PerDistrictContainer';
import TakeNotes from './TakeNotes';


export function testProps(props = {}) {
  return {
    nowMoment: nowMoment,
    currentEducator: currentEducator,
    onSave: jest.fn(),
    onCancel: jest.fn(),
    onClickNoteType: jest.fn(),
    onChangeNoteInProgressText: jest.fn(),
    onChangeAttachmentUrl: jest.fn(),
    requestState: null,
    noteInProgressText: '',
    noteInProgressType: null,
    noteInProgressAttachmentUrls: [],
    ...props
  };
}

function renderTestEl(props = {}, context = {}) {
  const districtKey = context.districtKey || SOMERVILLE;
  const el = document.createElement('div');
  ReactDOM.render(
    <PerDistrictContainer districtKey={districtKey}>
      <TakeNotes {...props} />
    </PerDistrictContainer>
  , el);

  return {el};
}

function buttonTexts(el) {
  return $(el).find('.btn.note-type').toArray().map(el => $(el).text());
}

it('renders without crashing', () => {
  const props = testProps();
  const {el} = renderTestEl(props);

  expect(el.innerHTML).toContain('February 11, 2016');
  expect(el.innerHTML).toContain('demo@example.com');
  expect($(el).find('textarea').length).toEqual(1);
  expect($(el).find('.btn.note-type').length).toEqual(8);
  expect($(el).find('.btn.save').length).toEqual(1);
  expect($(el).find('.btn.cancel').length).toEqual(1);
});


describe('buttons for taking notes', () => {
  it('works for Somerville', () => {
    const {el} = renderTestEl(testProps(), { districtKey: SOMERVILLE });
    expect(buttonTexts(el)).toEqual([
      'SST Meeting',
      'MTSS Meeting',
      'Parent conversation',
      'Something else',
      '9th Grade Experience',
      '10th Grade Experience',
      'NEST',
      'Counselor Meeting'
    ]);
  });

  it('works for New Bedford', () => {
    const {el} = renderTestEl(testProps(), { districtKey: NEW_BEDFORD });
    expect(buttonTexts(el)).toEqual([
      'BBST Meeting',
      'Parent conversation',
      'Something else'
    ]);
  });

  it('works for New Bedford', () => {
    const {el} = renderTestEl(testProps(), { districtKey: BEDFORD });
    expect(buttonTexts(el)).toEqual([
      'STAT Meeting',
      'Parent conversation',
      'Something else',
      'CAT Meeting',
      '504 Meeting',
      'SPED Meeting'
    ]);
  });
});

it('showRestrictedCheckbox', () => {
  const props = testProps({showRestrictedCheckbox: true});
  const {el} = renderTestEl(props);

  expect(el.innerHTML).toContain('Restrict access?');
  expect(el.innerHTML).toContain('Yes, note contains private or sensitive personal information');
  const $checkboxEl = $(el).find('input[type=checkbox]');
  expect($checkboxEl.length).toEqual(1);
});
