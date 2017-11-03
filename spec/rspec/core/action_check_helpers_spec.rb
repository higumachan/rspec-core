require 'thread_order'


module RSpec::Core
  RSpec.describe ActionCheckHelpers do
    before do
      @nadeko_is = nil
      @rikka_is = nil
      @noe_is = nil
    end

    
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

        branch 'nest1 nest1' do
          action 'set noe is cute' do
            @noe_is = 'cute'
          end

          check 'nadeko_is = "cute" and rikka_is = "cute" and noe_is = "cute"' do
            expect(@nadeko_is).to eq 'cute'
            expect(@rikka_is).to eq 'cute'
            expect(@noe_is).to eq 'cute'
          end
        end
        branch 'nest1 nest2' do
          check 'nadeko_is = "cute" and rikka_is = "cute" and noe_is is nil' do
            expect(@nadeko_is).to eq 'cute'
            expect(@rikka_is).to eq 'cute'
            expect(@noe_is).to be_nil
          end
        end
      end

      branch 'nest2' do
        check 'nadeko_is = "cute" and rikka_is is nil' do
          expect(@nadeko_is).to eq 'cute'
          expect(@rikka_is).to be_nil
        end
      end
    end

    actions 'only context' do
      action 'set rikka is cute' do
        @rikka_is = 'cute'
      end

      check 'nadeko_is be nil' do
        expect(@nadeko_is).to be_nil
      end
    end

  end
end
