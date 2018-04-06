class CompletedTaskException < StandardError

    def initialize(task_id)
        @task_id = task_id
    end

    def message
        "Task #{@task_id} already completed"
    end
end