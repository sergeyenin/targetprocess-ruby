require 'spec_helper'

  describe Targetprocess::EntityCommons, vcr: true do
    before do
      Targetprocess.configure do |config|
        config.domain = 'http://kamrad.tpondemand.com/api/v1'
        config.username = 'admin'
        config.password = 'admin'
      end

    end

    describe '.new' do
      it "creates an instance of Targetprocess::Task" do
        item = Targetprocess::Task.new

        expect(item).to be_an_instance_of(Targetprocess::Task)
      end
    end

    describe '.all' do
      it "returns all Targetprocess::Task" do
        result = Targetprocess::Task.all

        expect(result).to be_an_instance_of(Array)
        result.each do |item|
          expect(item).to be_an_instance_of(Targetprocess::Task)
        end
      end

      it "returns all Targetprocess::Task with conditions " do
        result = Targetprocess::Task.all(take: 1)
       
        expect(result).to be_an_instance_of(Array)
        expect(result.first).to be_an_instance_of(Targetprocess::Task)
      end
    end

    describe '.find' do
      it "returns requested Targetprocess::Task " do
        item = Targetprocess::Task.find(185) 

        expect(item).to be_an_instance_of(Targetprocess::Task)
        expect(item.id).to eql(185)
      end      

      it "returns requested Targetprocess::Task " do
        item = Targetprocess::Task.find(185) 

        expect(item).to be_an_instance_of(Targetprocess::Task)
        expect(item.id).to eql(185)
      end

      it "raise Targetprocess::BadRequest error" do
        expect{
          Targetprocess::Task.find("asd")
        }.to raise_error(Targetprocess::BadRequest)
      end

      it "raise an Targetprocess::NotFound error" do                     
        expect {
          Targetprocess::Task.find(1234)
        }.to raise_error(Targetprocess::NotFound) 
      end

    end

    describe ".where" do
      it "return array of Targetprocess::Task" do 
        response = Targetprocess::Task.where('createdate lt "2014-10-10"') 
        
        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end      
      it "return array of Targetprocess::Task with conditions" do 
        search = 'createdate lt "2014-10-10"'
        response = Targetprocess::Task.where(search, orderbydesc: 'id', take: 1) 
        
        expect(response).to have(1).task
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end

      it "return array of Targetprocess::Task" do 
        options = '(createdate lt "2014-07-08")and(createdate gt "1991-01-01")'
        response = Targetprocess::Task.where(options) 

        expect(response).to be_an_instance_of(Array) 
        expect(response.first).to be_an_instance_of(Targetprocess::Task)
      end

      it "raise an Targetprocess::BadRequest" do 
        expect {
          Targetprocess::Task.where('asdsd lt 1286')
        }.to raise_error(Targetprocess::BadRequest) 
      end

      it "raise an Targetprocess::BadRequest " do
        conditions = '(asdsd lt 1286)and(createdate lt "2013-10-10")'
        expect {
          Targetprocess::Task.where(conditions)
        }.to raise_error(Targetprocess::BadRequest) 
      end
    end

    describe "#meta" do
      it "returns task's metadata" do 
        response = Targetprocess::Task.meta
        description = "A small chunk of work, typically less than 16 hours. Task must relate to User Story. It is not possible to create Tasks without User Story."
        
        expect(response[:name]).to eq("Task")
        expect(response[:description]).to match(description)
      end
    end

    describe "#delete" do
      it "delete #{Targetprocess::Task} with the greatest id" do
        item = Targetprocess::Task.all(createondesc: "id", take: 1).first
        resp = item.delete

        expect(resp).to eq(true)
        expect{item.delete}.to raise_error(Targetprocess::NotFound)
        expect{
          Targetprocess::Task.find(item.id) 
        }.to raise_error(Targetprocess::NotFound)
      end
    end

    describe "#save" do
      it "create new task and save it on remote host " do
        props = { name: "Task-#{Time.now.to_i}", userstory: {id: 531}, 
                 priority: {id: 11} } 
        item = Targetprocess::Task.new(props)
        item.save 
        id = Targetprocess::Task.all(orderbydesc: 'id', take: 1 ).first.id

        expect(item).to be_an_instance_of(Targetprocess::Task)
        expect(id).to eq(item.id)
      end

      it "updates task on remote host " do

        item = Targetprocess::Task.all(orderbydesc: "id", take: 1).first
        item.name = "new task name"
        item.save 

        expect(Targetprocess::Task.find(item.id)).to eq(item)
      end

      it 'test' do
        task = Targetprocess::Task.new({:name => 'test', :userstory => {id:531}})
        expect(task.name).to eq('test')
        task.name = 'old name'
        expect(task.name).to eq('old name')
        task.save
        expect(task.name).to eq('old name')
        task.name = 'new name'
        expect(task.name).to eq('new name')
        task.save
        expect(task.name).to eq('new name')
      end
    end

  end
