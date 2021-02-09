class ItemsController < ApplicationController
before_action :find_item, only: [:edit, :show, :update, :destroy, :complete]
# before_action :authenticate_user!
    def index
      if user_signed_in?
        @items = Item.where(:user_id => current_user.id).order(created_at: :desc)
      end
    end

    def new
        @item = current_user.item.build
    end

    def create
        @item = current_user.item.build(item_params)
        if @item.save
          flash[:success] = "Object successfully created"
          redirect_to @item
        else
          flash[:error] = "Something went wrong"
          render 'new'
        end
    end

    def edit

    end

    def show
    end

    def complete
        if @item.completed?
            @item.update_attribute(:completed_at,nil)
        else
          @item.update_attribute(:completed_at,Time.now)
        end
        redirect_to root_path
    end
    def update
        if @item.update(item_params)
          flash[:success] = "Object was successfully updated"
          redirect_to @item
        else
          flash[:error] = "Something went wrong"
          render 'edit'
        end
    end

    def destroy

        if @item.destroy
            flash[:success] = 'Object was successfully deleted.'
            redirect_to items_path
        else
            flash[:error] = 'Something went wrong'
            redirect_to @item
        end
    end

    private

    def find_item
        @item = Item.find(params[:id])
    end

    def item_params
        params.require(:item).permit(:title,:description,:user_id)
    end

end
