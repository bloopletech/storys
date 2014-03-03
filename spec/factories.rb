FactoryGirl.define do
  factory :package, class: 'Storys::Package' do
    path { Pathname.new(".") }
    initialize_with { new(path) }
  end

  factory :story, class: 'Storys::Story' do
    path { Pathname.new(".") }
    initialize_with { new(build(:package), path) }
  end
end
