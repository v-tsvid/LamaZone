shared_examples "customer authentication" do
  it "receives :authenticate_customer!" do
    expect(controller).to receive(:authenticate_customer!)
    subject
  end
end

shared_examples "authorize resource" do
  it "receives :authorize!" do
    expect(controller).to receive(:authorize!)
    subject
  end
end

shared_examples "load resource" do
  it "receives :load_resource" do
    expect_any_instance_of(
      CanCan::ControllerResource).to receive(:load_resource)
    subject
  end
end

shared_examples 'load and authorize resource' do |resource|
  it_behaves_like "load resource", resource do 
    before do
      controller.instance_variable_set(
        "@#{resource}".to_sym, FactoryGirl.build(resource))
    end
  end

  it_behaves_like "authorize resource"
end

shared_examples 'check abilities' do |method, resource|
  before do 
    setup_ability
    @ability.cannot method, resource
  end

  it "redirects if unauthorized" do
    expect(subject).to redirect_to root_path
  end

  it_behaves_like 'flash setting', :alert, t("unauthorized.default")
end

shared_examples "redirecting to :back" do
  it "redirects to :back" do
    expect(subject).to redirect_to request.env["HTTP_REFERER"]
  end
end

shared_examples "redirecting to root_path" do
  it "redirects to root_path" do
    expect(subject).to redirect_to root_path
  end
end

shared_examples "flash setting" do |key, message|
  it "sets :#{key}" do
    subject
    expect(flash[key]).to eq message
  end
end

shared_examples 'assigning' do |var|
  it "assigns @#{var}" do
    subject
    expect(assigns var).not_to be_nil
  end
end

shared_examples 'state_enum testing' do |klass|
  let(:object) { FactoryGirl.create(klass) }
  subject { object.state_enum }

  it "returns STATE_LIST" do
    expect(subject).to eq object.class::STATE_LIST
  end
end