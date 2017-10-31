require 'thread_order'


module RSpec::Core
  RSpec.describe ActionCheckHelpers do
    before do
      @nadeko_is = nil
      @rikka_is = nil
    end

    actions 'first action' do
      action :nadeko, 'set nadeko is cute' do
        @nadeko_is = 'cute'
      end

      check 'nadeko_is = "cute"' do
        expect(@nadeko_is).to eq 'cute'
      end

      action :rikka, 'set rikka is cute' do
        @rikka_is = 'cute'
      end

      check 'nadeko_is = "cute" and rikka_is = "cute"' do
        expect(@nadeko_is).to eq 'cute'
        expect(@rikka_is).to eq 'cute'
      end
    end

    actions 'only context' do
      action :rikka, 'set rikka is cute' do
        @rikka_is = 'cute'
      end

      check 'nadeko_is be nil' do
        expect(@nadeko_is).to be_nil
      end
    end

    actions 'use before_action_name' do
      action :nadeko, 'set nadeko is cute' do
        @nadeko_is = 'cute'
      end
      check 'nadeko_is = "cute"' do
        expect(@nadeko_is).to eq 'cute'
      end

      action :rikka, 'set rikka is cute' do
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
  end
end
