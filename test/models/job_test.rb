require 'test_helper'

describe Job do
  describe "when company, title, and start date are not unique" do
    let(:dup_job) do
      data = {company: "company", title: "title", start_date: Date.new(2014,01,13), end_date: Date.new(2014,01,14)}
      Job.create(data)  # the original
      Job.create(data)  # the duplicate
    end
    it "creates the error: this job already exists" do
      dup_job.errors[:company].must_include "- this job already exists (same company, title, and start date)"
    end
  end
  
  describe "when end date is before start date" do
    let(:job) { Job.create({start_date: Date.new(2014,01,14), end_date: Date.new(2014,01,13)}) }
    it "creates the error: end date cannot be before start date" do
      job.errors[:base].must_include "end date cannot be before start date"
    end
  end

  describe "when start date and end date are the same" do
    let(:job) { Job.create({start_date: Date.new(2014,01,13), end_date: Date.new(2014,01,13)}) }
    it "does not create any errors" do
      job.errors[:base].must_be_empty
    end
  end
  
  describe "company" do
    describe "when it is 2 characters" do
      let(:job) { Job.create({company: "a" * 2}) }
      it "does not create any errors" do
        job.errors[:company].must_be_empty
      end
    end

    describe "when it is 100 characters" do
      let(:job) { Job.create({company: "a" * 100}) }
      it "does not create any errors" do
        job.errors[:company].must_be_empty
      end
    end

    describe "when it has leading whitespace" do
      let(:job) { Job.create({company: " \t\na"}) }
      it "strips the leading whitespace" do
        job.company.must_equal "a"
      end
    end

    describe "when it has trailing whitespace" do
      let(:job) { Job.create({company: "a \t\n"}) }
      it "strips the trailing whitespace" do
        job.company.must_equal "a"
      end
    end

    describe "when it is missing" do
      let(:job) { Job.create }
      it "creates the error: is too short" do
        job.errors[:company].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 1 character" do
      let(:job) { Job.create({company: "a"}) }
      it "creates the error: is too short" do
        job.errors[:company].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 2 blanks" do
      let(:job) { Job.create({company: " " * 2}) }
      it "creates the error: is too short" do
        job.errors[:company].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 100 blanks" do
      let(:job) { Job.create({company: " " * 100}) }
      it "creates the error: is too short" do
        job.errors[:company].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 101 characters" do
      let(:job) { Job.create({company: "a" * 101}) }
      it "creates the error: is too long" do
        job.errors[:company].must_include "is too long (maximum is 100 characters)"
      end
    end
  end

  describe "title" do
    describe "when it is 2 characters" do
      let(:job) { Job.create({title: "a" * 2}) }
      it "does not create any errors" do
        job.errors[:title].must_be_empty
      end
    end

    describe "when it is 100 characters" do
      let(:job) { Job.create({title: "a" * 100}) }
      it "does not create any errors" do
        job.errors[:title].must_be_empty
      end
    end

    describe "when it has leading whitespace" do
      let(:job) { Job.create({title: " \t\na"}) }
      it "strips the leading whitespace" do
        job.title.must_equal "a"
      end
    end

    describe "when it has trailing whitespace" do
      let(:job) { Job.create({title: "a \t\n"}) }
      it "strips the trailing whitespace" do
        job.title.must_equal "a"
      end
    end

    describe "when it is missing" do
      let(:job) { Job.create }
      it "creates the error: is too short" do
        job.errors[:title].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 1 character" do
      let(:job) { Job.create({title: "a"}) }
      it "creates the error: is too short" do
        job.errors[:title].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 2 blanks" do
      let(:job) { Job.create({title: " " * 2}) }
      it "creates the error: is too short" do
        job.errors[:title].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 100 blanks" do
      let(:job) { Job.create({title: " " * 100}) }
      it "creates the error: is too short" do
        job.errors[:title].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 101 characters" do
      let(:job) { Job.create({title: "a" * 101}) }
      it "creates the error: is too long" do
        job.errors[:title].must_include "is too long (maximum is 100 characters)"
      end
    end
  end
  
  describe "start_date" do
    describe "when it is missing" do
      let(:job) { Job.create }
      it "creates the error: can't be blank" do
        job.errors[:start_date].must_include "can't be blank"
      end
    end
    
    describe "when it is in the distant past" do
      let(:job) { Job.create({start_date: Date.new(1900,01,13)}) }
      it "does not create any errors" do
        job.errors[:start_date].must_be_empty
      end
    end
    
    describe "when it is in the distant future" do
      let(:job) { Job.create({start_date: Date.new(2100,01,13)}) }
      it "does not create any errors" do
        job.errors[:start_date].must_be_empty
      end
    end
  end
  
  describe "end_date" do
    describe "when it is missing" do
      let(:job) { Job.create }
      it "creates the error: can't be blank" do
        job.errors[:end_date].must_include "can't be blank"
      end
    end
    
    describe "when it is in the distant past" do
      let(:job) { Job.create({end_date: Date.new(1900,01,13)}) }
      it "does not create any errors" do
        job.errors[:end_date].must_be_empty
      end
    end
    
    describe "when it is in the distant future" do
      let(:job) { Job.create({end_date: Date.new(2100,01,13)}) }
      it "does not create any errors" do
        job.errors[:end_date].must_be_empty
      end
    end
  end
end
