class BankStatementLoader
  def initialize(admin, statement_string)
    @admin, @statement = admin, statement_string
  end

  def load
    ActiveRecord::Base.transaction do
      save_statement
    end
  end

  private
    
    def save_statement
      BankStatement.create admin_id: @admin.id, 
                           contents: @statement
    end
end
