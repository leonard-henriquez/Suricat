# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  after_create { logger.info "#{self.class} created: #{attributes.inspect}" }
  after_commit { logger.info "#{self.class} saved: #{attributes.inspect}" }
  after_rollback { logger.warn "#{self.class} failed to save: #{errors.messages.inspect}" }
  before_destroy { logger.info "#{self.class} to be destroyed: #{attributes.inspect}" }
end
