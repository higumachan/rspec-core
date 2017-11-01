require 'thread_order'


module RSpec::Core
  RSpec.describe ActionCheckHelpers do
    before do
      @nadeko_is = nil
      @rikka_is = nil
    end

=begin
    actions 'first action' do
      action 'set nadeko is cute' do
        @nadeko_is = 'cute'
      end

      check 'nadeko_is = "cute"' do
        expect(@nadeko_is).to eq 'cute'
      end

      action 'set rikka is cute' do
        @rikka_is = 'cute'
      end

      check 'nadeko_is = "cute" and rikka_is = "cute"' do
        expect(@nadeko_is).to eq 'cute'
        expect(@rikka_is).to eq 'cute'
      end
    end

    actions 'empty actions' do
    end
=end

    actions 'branch' do
      action 'set nadeko is cute' do
        @nadeko_is = 'cute'
      end

      branch 'nest1' do
        check 'nadeko_is = "cute"' do
          expect(@nadeko_is).to eq 'cute'
        end

        action 'set rikka is cute' do
          @rikka_is = 'cute'
        end

        check 'nadeko_is = "cute" and rikka_is = "cute"' do
          expect(@nadeko_is).to eq 'cute'
          expect(@rikka_is).to eq 'cute'
        end
      end

      branch 'nest2' do
        check 'nadeko_is = "cute" and rikka_is is nil' do
          expect(@nadeko_is).to eq 'cute'
          expect(@rikka_is).to be_nil
        end
      end
    end

=begin
    actions 'only context' do
      action 'set rikka is cute' do
        @rikka_is = 'cute'
      end

      check 'nadeko_is be nil' do
        expect(@nadeko_is).to be_nil
      end
    end

    actions 'use before_action_name' do
      action 'set nadeko is cute', :nadeko do
        @nadeko_is = 'cute'
      end
      check 'nadeko_is = "cute"' do
        expect(@nadeko_is).to eq 'cute'
      end

      action 'set rikka is cute' do
        @rikka_is = 'cute'
      end
      check 'nadeko_is = "cute" and rikka_is = "cute"' do
        expect(@nadeko_is).to eq 'cute'
        expect(@rikka_is).to eq 'cute'
      end

      check 'nadeko_is = "cute" and rikka_is is nil', :nadeko do
        expect(@nadeko_is).to eq 'cute'
        expect(@rikka_is).to be_nil
      end

    end
=end
  end
end
