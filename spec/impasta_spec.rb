require 'rspec'
require 'impasta'

describe Impasta do
  context 'named impasta' do
    subject(:imp){ Impasta.new 'whatever' }

    it 'tracks passed in messsages' do
      imp.foo
      imp.bar

      expect(imp.impasta_dump[:methods].map{|name,_,_| name}).to eq([:foo,:bar])
    end
  end

  context 'has source object' do
    subject(:imp){ Impasta.new Array }

    it 'dissallows methods unknown to the source object' do
      expect{ imp.nonexistant_method }.to raise_error
    end

    it 'captures errors and makes them debuggable' do
      begin
        imp.nonexistant_method
      rescue Impasta::ImpastaNoMethodError => error
        expect(error.parent_exception).to be # this is the original error, should you need it
        expect(error.definition).to be # this is where you defined the Impasta object
        expect(error.accessed_methods).to be # this will be a list of any of the methods called on it
        expect(error.object).to be # this is what Impasta thinks the object should be
        expect(error.method_name).to be # this is the method that wasn't found
      end
    end

  end
end
