shared_examples 'any customer' do
  ['Author', 'Book', 'Category', 'Rating'].each do |item|
    it "can read any #{item.downcase}" do
      expect(subject).to have_abilities(:read, item.constantize)
    end
  end
end