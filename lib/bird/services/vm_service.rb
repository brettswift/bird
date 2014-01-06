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
      taskid = self.vconnection.create_vm_snapshot(vm_id)

      wait_for_task(taskid)
    end

    desc "","", :hide => true
    def revert_vm_snapshot(vm_id)
      taskid = self.vconnection.revert_vm_snapshot(vm_id)
      wait_for_task(taskid)
    end

    desc "","", :hide => true
    def wait_for_task(taskid)
      notice "waiting for task to complete . . . "
      self.vconnection.wait_task_completion(taskid)
      ok "completed!"
    end

  end
end


