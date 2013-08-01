require 'spec_helper'

shared_examples "an entity" do
  let(:all) { described_class.all}

  describe described_class do
    before do
      Targetprocess.configure do |config|
        config.domain = 'http://kamrad.tpondemand.com/api/v1'
        config.username = 'admin'
        config.password = 'admin'
      end
    end

    describe '.new' do
      it "creates an instance of #{described_class}" do
        item = described_class.new

        expect(item).to be_an_instance_of(described_class)
      end
    end

    describe '.all', :vcr => true do
      it "returns all #{described_class} or empty array" do
        result = described_class.all

        expect(result).to be_an_instance_of(Array)
        if all.length > 0
          result.each do |item|
            expect(item).to be_an_instance_of(described_class)
          end
        end
      end

      it "returns all #{described_class} with conditions or empty array" do
        result = described_class.all(take: 1)
        expect(result).to be_an_instance_of(Array)

        if all.length > 0        
          expect(result.first).to be_an_instance_of(described_class)
        end
      end
    end

    describe '.find', :vcr => true do
      it "returns requested #{described_class} or nil if no remote entities" do
        item = described_class.find(all.first.id) if all.first

        if all.count > 0 
          expect(item).to be_an_instance_of(described_class)
          expect(item.id).to eql(all.first.id)
        else
          expect(item).to be_nil
        end
      end

      it "raise Targetprocess::BadRequest error" do
        expect{
          described_class.find("asd")
        }.to raise_error(Targetprocess::BadRequest)
      end

      it "raise an Targetprocess::NotFound error" do                     
        expect {
          described_class.find(1234)
        }.to raise_error(Targetprocess::NotFound) 
      end

    end

    describe ".where" do
      if described_class.instance_methods.include?(:createdate)
        it "return array of #{described_class}" do 
          response = described_class.where('createdate lt "2014-10-10"') 
          expect(response).to be_an_instance_of(Array) 
          if all.count > 0
            expect(response.first).to be_an_instance_of(described_class)
          end
        end

        it "return array of #{described_class}" do 
          options = '(createdate lt "2014-07-08")and(createdate gt "1991-01-01")'
          response = described_class.where(options) 

          expect(response).to be_an_instance_of(Array) 
          if all.count > 0
            expect(response.first).to be_an_instance_of(described_class)
          end
        end
      end
      it "raise an Targetprocess::BadRequest" do 
        expect {
          described_class.where('asdsd lt 1286')
        }.to raise_error(Targetprocess::BadRequest) 
      end

      it "raise an Targetprocess::BadRequest " do
        conditions = '(asdsd lt 1286)and(createdate lt "2013-10-10")'
        expect {
          described_class.where(conditions)
        }.to raise_error(Targetprocess::BadRequest) 
      end
    end

    # describe "#save" do
    #   it "create #{described_class} on remote host " do
    #     item = described_class.new
    #     {name: "Test #{described_class}-#{Time.now.to_i}", description: "something",
    #      project: {id: 221}, owner:{id: 2}, 
    #      enddate: Time.now, general: {id:182},
    #      startdate: Time.now+10 ,
    #      enddate: Time.new(2013,12,28,8,0,0,"+03:00"),
    #      release:{id: 282}, userstory: {id: 234},
    #      steps: "check", success: "ok", 
    #      email: "test#{Time.now.to_i}@gmail.com",
    #      login: "user-#{Time.now.to_i}", password: "secretsecret",
    #      entitytype: {id: 12}, testplan: {id: 57},
    #      testplanrun: {id: 217}, assignable: {id: 143},
    #      generaluser: {id: 1}, role: {id: 1}, user: {id: 1},
    #      testcase:{id: 467}
    #      }.each do |k,v|
    #        if described_class.attributes["writable"].include?(k.to_s) && !(described_class.to_s.demodulize.downcase == k.to_s )
    #           item.send(k.to_s+"=", v) 
    #        end
    #      end
    #      p item
    #     expect(item.save).to be_an_instance_of(described_class)
    #   end
    # end

    # describe "#delete" do
    #   it "delete #{described_class} with the greatest id" do
    #     item = described_class.all(orderbydesc: "id").first
    #     p item.id
    #     item.delete
    #     expect{
    #       described_class.find(item.id) 
    #     }.to raise_error(Targetprocess::NotFound)
    #   end
    # end

  end
end     
