module SimpleRoles
  module Configuration
    extend self
    
    attr_accessor :valid_roles, :user_models
    attr_writer :strategy

    def user_models
      @user_models ||= []
    end

    def valid_roles= vr
      raise "There should be an array of valid roles" if !vr.kind_of?(Array)
      @valid_roles = vr
      
      distribute_methods
    end

    def valid_roles
      @valid_roles || default_roles
    end

    def default_roles
      [:user, :admin]
    end

    def distribute_methods
      user_models.each(&:register_roles_methods)
    end

    def strategy st = nil
      if st
        @strategy = st
      end

      @strategy ||= default_strategy
    end

    private

    def available_strategies
      strategies.keys
    end

    def default_strategy
      :one
    end

    def strategy_class
      strategies[strategy]
    end

    def strategies
      {
        :one => SimpleRoles::One,
        :many => SimpleRoles::Many
      }
    end
  end
end
