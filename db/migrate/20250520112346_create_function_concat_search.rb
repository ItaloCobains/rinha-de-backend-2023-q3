class CreateFunctionConcatSearch < ActiveRecord::Migration[8.0]
  def change
    create_function :concat_search
  end
end
