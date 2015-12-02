shared_examples_for 'publishable' do
  it 'publishes object' do
    expect(PrivatePub).to receive(:publish_to).with(publish_url, anything)
    subject
  end
end