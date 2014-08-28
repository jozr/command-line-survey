require 'spec_helper'

describe Answer do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :answer }
  it { should ensure_length_of(:answer).is_at_most(1) }

  it { should belong_to :question }
  it { should belong_to :user }
end