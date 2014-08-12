require 'test_helper'

describe Job do
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
  
  describe "synopsis" do
    describe "when it is missing" do
      let(:job) { Job.create({synopsis: nil}) }
      it "does not create any errors" do
        job.errors[:synopsis].must_be_empty
      end
    end

    describe "when it is empty" do
      let(:job) { Job.create({synopsis: ""}) }
      it "does not create any errors" do
        job.errors[:synopsis].must_be_empty
      end
    end
    
    describe "when it is blank" do
      let(:job) { Job.create({synopsis: " " * 100})}
      it "does not create any errors" do
        job.errors[:synopsis].must_be_empty
      end
      
      it "is converted to an empty string" do
        job.synopsis.must_equal ""
      end
    end

    describe "when it is 10,000 characters" do
      let(:job) { Job.create({synopsis: "a" * 10_000}) }
      it "does not create any errors" do
        job.errors[:synopsis].must_be_empty
      end
    end

    describe "when it has leading whitespace" do
      let(:job) { Job.create({synopsis: " \t\na"}) }
      it "strips the leading whitespace" do
        job.synopsis.must_equal "a"
      end
    end

    describe "when it has trailing whitespace" do
      let(:job) { Job.create({synopsis: "a \t\n"}) }
      it "strips the trailing whitespace" do
        job.synopsis.must_equal "a"
      end
    end

    describe "when it is 10,001 characters" do
      let(:job) { Job.create({synopsis: "a" * 10_001}) }
      it "creates the error: is too long" do
        job.errors[:synopsis].must_include "is too long (maximum is 10000 characters)"
      end
    end
  end
end
