shared_examples 'setting alert within address errors' do
  it_behaves_like 'flash setting', :alert, 'error1. error2' do
    before do
      allow_any_instance_of(Address).
        to receive_message_chain("errors.full_messages").
          and_return(['error1', 'error2'])
    end
  end
end