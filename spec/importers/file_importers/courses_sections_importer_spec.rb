require 'rails_helper'

RSpec.describe CoursesSectionsImporter do

  describe '#import_row' do
    let!(:school) { FactoryGirl.create(:shs) }

    context 'happy path' do
      let(:row) { { course_number:'ART-205', 
                    course_description:'Handmade Ceramics I', 
                    section_number:'ART-205B', 
                    school_local_id: 'SHS',
                    term_local_id:'FY', 
                    section_schedule:'3(M-R)', 
                    section_room_number:'232B'
                } }

        before do
          described_class.new.import_row(row)
        end

        it 'creates a course' do
          expect(Course.count).to eq(1)
        end

        it 'creates a section' do
          expect(Section.count).to eq(1)
        end

        it 'creates a section of the course' do
          expect(Section.first.course).to eq(Course.first)
        end
      end
    end
  end