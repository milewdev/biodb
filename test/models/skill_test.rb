require 'test_helper'

describe Skill do
  describe "when the name is not unique within a job" do
    let(:dup_skill) do
      data = {job_id: 1, name: "name", group: "group"}
      Skill.create(data)  # the original
      Skill.create(data)  # the duplicate
    end
    it "creates the error: this skill already exists for this job" do
      dup_skill.errors[:job_id].must_include "- this skill already exists for this job (same name)"
    end
  end
  
  describe "name" do
    describe "when it is 2 characters" do
      let(:skill) { Skill.create({name: "a" * 2}) }
      it "does not create any errors" do
        skill.errors[:name].must_be_empty
      end
    end

    describe "when it is 100 characters" do
      let(:skill) { Skill.create({name: "a" * 100}) }
      it "does not create any errors" do
        skill.errors[:name].must_be_empty
      end
    end

    describe "when it has leading whitespace" do
      let(:skill) { Skill.create({name: " \t\na"}) }
      it "strips the leading whitespace" do
        skill.name.must_equal "a"
      end
    end

    describe "when it has trailing whitespace" do
      let(:skill) { Skill.create({name: "a \t\n"}) }
      it "strips the trailing whitespace" do
        skill.name.must_equal "a"
      end
    end

    describe "when it is missing" do
      let(:skill) { Skill.create }
      it "creates the error: is too short" do
        skill.errors[:name].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 1 character" do
      let(:skill) { Skill.create({name: "a"}) }
      it "creates the error: is too short" do
        skill.errors[:name].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 2 blanks" do
      let(:skill) { Skill.create({name: " " * 2}) }
      it "creates the error: is too short" do
        skill.errors[:name].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 100 blanks" do
      let(:skill) { Skill.create({name: " " * 100}) }
      it "creates the error: is too short" do
        skill.errors[:name].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 101 characters" do
      let(:skill) { Skill.create({name: "a" * 101}) }
      it "creates the error: is too long" do
        skill.errors[:name].must_include "is too long (maximum is 100 characters)"
      end
    end
  end
  
  describe "group" do
    describe "when it is 2 characters" do
      let(:skill) { Skill.create({group: "a" * 2}) }
      it "does not create any errors" do
        skill.errors[:group].must_be_empty
      end
    end

    describe "when it is 100 characters" do
      let(:skill) { Skill.create({group: "a" * 100}) }
      it "does not create any errors" do
        skill.errors[:group].must_be_empty
      end
    end

    describe "when it has leading whitespace" do
      let(:skill) { Skill.create({group: " \t\na"}) }
      it "strips the leading whitespace" do
        skill.group.must_equal "a"
      end
    end

    describe "when it has trailing whitespace" do
      let(:skill) { Skill.create({group: "a \t\n"}) }
      it "strips the trailing whitespace" do
        skill.group.must_equal "a"
      end
    end

    describe "when it is missing" do
      let(:skill) { Skill.create }
      it "creates the error: is too short" do
        skill.errors[:group].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 1 character" do
      let(:skill) { Skill.create({group: "a"}) }
      it "creates the error: is too short" do
        skill.errors[:group].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 2 blanks" do
      let(:skill) { Skill.create({group: " " * 2}) }
      it "creates the error: is too short" do
        skill.errors[:group].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 100 blanks" do
      let(:skill) { Skill.create({group: " " * 100}) }
      it "creates the error: is too short" do
        skill.errors[:group].must_include "is too short (minimum is 2 characters)"
      end
    end

    describe "when it is 101 characters" do
      let(:skill) { Skill.create({group: "a" * 101}) }
      it "creates the error: is too long" do
        skill.errors[:group].must_include "is too long (maximum is 100 characters)"
      end
    end
  end
end
