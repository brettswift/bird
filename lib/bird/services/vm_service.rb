require 'bird'
require 'bird/services/vcloud_connection'
require 'bird/domain/vapp'

module Bird
  class VmService <ThorBase
    include Bird

    def initialize(link = nil)
      next_in_chain(link)
    end

    desc "","", :hide => true
    def get_vm(vm_id)
      vm_raw = self.vconnection.get_vm(vm_id)
      vm = Bird::Vm.new.from_hash(vm_raw)
      return vm
    end


    desc "","", :hide => true
    def poweroff_vm(vm_id)
      taskid = self.vconnection.poweroff_vm(vm_id)
      wait_for_task(taskid)
    end

    desc "","", :hide => true
    def poweron_vm(vm_id)
      say("powering on . . . ")
      taskid = self.vconnection.poweron_vm(vm_id)
      wait_for_task(taskid)
    end

    desc "","", :hide => true
    def reboot_vm(vm_id)
      taskid = self.vconnection.reboot_vm(vm_id)
      wait_for_task(taskid)
    end

    desc "","", :hide => true
    def create_vm_snapshot(vm_id)
      say("Snapshot starting.  Expect to wait ~4min")
      taskid = self.vconnection.create_vm_snapshot(vm_id)
      alert("this could take around 4 minutes . . . please wait . . .")
      wait_for_task(taskid)
    end

    desc "","", :hide => true
    def revert_vm_snapshot(vm_id)
      say("Reverting to snapshot.  Expect to wait ~10-40 sec")
      taskid = self.vconnection.revert_vm_snapshot(vm_id)
      wait_for_task(taskid)
    end

    desc "","", :hide => true
    def wait_for_task(taskid)
      say("Starting Task at: #{Time.now}")
      notice("\r\nwaiting for task to complete. . . ")
      task_result = self.vconnection.wait_task_completion(taskid)
      if task_result[:errormsg]
        error task_result[:errormsg]
        return
      end
      started = Time.parse(task_result[:start_time])
      ended = Time.parse(task_result[:end_time])
      elapsed_seconds = ended - started

      say("Task completed in #{elapsed_seconds}s.")
      ok("Result: #{task_result[:status]}")
    end

  end
end


