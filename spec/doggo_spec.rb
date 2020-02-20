require 'spec_helper'

RSpec.describe 'Doggo examples' do
  context 'in a context' do
    context 'with a nested context' do

      it 'passes' do
        expect(true).to eql(true)
      end

      it 'fails' do
        expect(true).to eql(false)
      end

      xit 'is pending with xit' do
      end

      it 'is pending with a custom message' do
        pending('custom message')
      end
    end
  end

  it 'outer passes' do
    expect(true).to eql(true)
  end

  it 'outer fails' do
    expect(true).to eql(false)
  end

  xit 'outer is pending with xit' do
  end

  it 'outer is pending with a custom message' do
    pending('custom message')
  end

  context 'test count' do
    it 'is taken to 9' do
      expect(true).to eql(true)
    end

    it 'is taken to 10, showing leading zero pad formatting' do
      expect(true).to eql(true)
    end
  end
end