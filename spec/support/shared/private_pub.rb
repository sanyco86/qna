shared_examples_for 'publishable' do |channel|
  it 'publishes object' do
    expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    subject
  end
end