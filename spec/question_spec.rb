require 'spec_helper'

describe Question do
  it { should validate_presence_of :survey_id }
  it { should validate_presence_of :description }
  it { should validate_presence_of :a }
  it { should validate_presence_of :b }

  it { should have_many :answers }
  it { should belong_to :survey }
end