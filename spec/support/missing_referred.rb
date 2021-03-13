# frozen_string_literal: true

module Support
  module MissingReferred
    SANITIZED_HASH = [{ date: '2018-06-12',
                        time: '09:41',
                        referrer: 'A',
                        action: 'recommends',
                        referred: 'B' },
                      { date: '2018-06-14',
                        time: '09:41',
                        referrer: 'B',
                        action: 'accepts',
                        referred: nil },
                      { date: '2018-06-16',
                        time: '09:41',
                        referrer: 'B',
                        action: 'recommends',
                        referred: 'C' },
                      { date: '2018-06-16',
                        time: '09:41',
                        referrer: 'B',
                        action: 'recommends',
                        referred: nil },
                      { date: '2018-06-17',
                        time: '09:41',
                        referrer: 'C',
                        action: 'accepts',
                        referred: nil },
                      { date: '2018-06-19',
                        time: '09:41',
                        referrer: 'C',
                        action: 'recommends',
                        referred: 'D' },
                      { date: '2018-06-23',
                        time: '09:41',
                        referrer: 'B',
                        action: 'recommends',
                        referred: 'D' },
                      { date: '2018-06-25',
                        time: '09:41',
                        referrer: 'D',
                        action: 'accepts',
                        referred: nil }].freeze
  end
end
