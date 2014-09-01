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
  
  describe 'sort order' do
    describe 'when it is valid' do
      let(:highlight) {Highlight.create({content: 'content', sort_order: 1})}
      it 'does not have any errors' do
        highlight.errors[:sort_order].must_be_empty
      end
    end
    
    describe 'when it is zero' do
      let(:highlight) {Highlight.create({content: 'content', sort_order: 0})}
      it 'has the error "must be greater than 0"' do
        highlight.errors[:sort_order].must_include "must be greater than 0"
      end
    end
    
    describe 'when it is negative' do
      let(:highlight) {Highlight.create({content: 'content', sort_order: -1})}
      it 'has the error "must be greater than 0"' do
        highlight.errors[:sort_order].must_include "must be greater than 0"
      end
    end
    
    describe 'when it is missing' do
      let(:highlight) {Highlight.create({content: 'content', sort_order: nil})}
      it 'has the error "can\'t be blank"' do
        highlight.errors[:sort_order].must_include "can't be blank"
      end
    end
    
    describe 'when it is a duplicate' do
      let(:highlight) {
        users(:name1).highlights.create({content: 'content 1', sort_order: 1})
        users(:name1).highlights.create({content: 'content 2', sort_order: 1})
      }
      it 'has the error "sort_order must be unique"' do
        highlight.errors[:sort_order].must_include "highlight sort_order must be unique for each user"
      end
    end
    
    describe 'when it is not a number' do
      let(:highlight) {Highlight.create({content: 'content', sort_order: 'a'})}
      it 'has the error "is not a number"' do
        highlight.errors[:sort_order].must_include "is not a number"
      end
    end
  end
end
