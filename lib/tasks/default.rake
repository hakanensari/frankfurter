# frozen_string_literal: true

task default: ["rubocop", "db:test:prepare", "spec"]
