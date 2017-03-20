require 'rails_helper'

RSpec.describe EditablePage, type: :model do
  subject { build :editable_page }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'required_name'
  it_behaves_like 'required_slug'
end
