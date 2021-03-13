# frozen_string_literal: true

module Support
  module RefereeAcceptsTwice
    SANITIZED_HASH = [{ date: '2018-06-12',
                        time: '09:41',
                        actor: 'A',
                        action: 'recommends',
                        referee: 'B' },
                      { date: '2018-06-14',
                        time: '09:41',
                        actor: 'B',
                        action: 'accepts',
                        referee: nil },
                      { date: '2018-06-16',
                        time: '09:41',
                        actor: 'B',
                        action: 'recommends',
                        referee: 'C' },
                      { date: '2018-06-16',
                        time: '09:41',
                        actor: 'B',
                        action: 'recommends',
                        referee: nil },
                      { date: '2018-06-17',
                        time: '09:41',
                        actor: 'C',
                        action: 'accepts',
                        referee: nil },
                      { date: '2018-06-17',
                        time: '09:41',
                        actor: 'C',
                        action: 'accepts',
                        referee: nil },
                      { date: '2018-06-19',
                        time: '09:41',
                        actor: 'C',
                        action: 'recommends',
                        referee: 'D' },
                      { date: '2018-06-23',
                        time: '09:41',
                        actor: 'B',
                        action: 'recommends',
                        referee: 'D' },
                      { date: '2018-06-25',
                        time: '09:41',
                        actor: 'D',
                        action: 'accepts',
                        referee: nil }].freeze
  end
end