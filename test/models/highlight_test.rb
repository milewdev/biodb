require 'test_helper'

describe Highlight do
  describe 'content' do
    describe 'when it is valid' do
      let(:highlight) {Highlight.create({content: 'this is some valid content'})}
      it 'does not have any errors' do
        highlight.errors[:content].must_be_empty
      end
    end
    
    describe 'when it is missing' do
      let(:highlight) {Highlight.create({content: nil})}
      it 'has the error "can\'t be blank"' do
        highlight.errors[:content].must_include "can't be blank"
      end
    end
    
    describe 'when it is empty' do
      let(:highlight) {Highlight.create({content: ''})}
      it 'has the error "can\'t be blank"' do
        highlight.errors[:content].must_include "can't be blank"
      end
    end
    
    describe 'when it is blank' do
      let(:highlight) {Highlight.create({content: ' '})}
      it 'has the error "can\'t be blank"' do
        highlight.errors[:content].must_include "can't be blank"
      end
    end
  end
end
