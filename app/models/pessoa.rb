class Pessoa < ApplicationRecord
  self.ignored_columns = %w[searchable]

  serialize :stack, type: Array, coder: TagCoder

  scope :search, -> (value) {
    return none if value.blank?

    if value.length <= 2
      where("pessoas.searchable ILIKE ?", "%#{value}%")
    else
      where("pessoas.searchable % ? OR pessoas.searchable ILIKE ?", value, "%#{value}%")
        .order(Arel.sql("similarity(pessoas.searchable, #{connection.quote(value)}) DESC"))
    end
  }

  validates :apelido,    presence: true, length: { maximum: 32  }
  validates :nome,       presence: true, length: { maximum: 100 }
  validates :nascimento, presence: true

  validate :stack_must_contain_valid_elements

  private
    def stack_must_contain_valid_elements
      errors.add(:stack, :invalid) unless stack.all? { |item| valid_stack_element?(item) }
    end

    def valid_stack_element?(item)
      item.is_a?(String) && item.present? && item.size <= 32
    end
end
