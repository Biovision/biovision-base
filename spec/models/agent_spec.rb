require 'rails_helper'

RSpec.describe Agent, type: :model do
  subject { build :agent }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'required_name'
end
