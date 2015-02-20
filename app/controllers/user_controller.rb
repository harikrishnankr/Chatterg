class UserController < ApplicationController
  def index
    @total_msg=Message.where("created_at >= ?", Time.zone.now.beginning_of_day).reverse
    @online=User.where("login=? AND id!= ?",1,session[:id])
    #flash[:notice]="#{@online}"
  end
  def msg_send
  	msg=Message.new
  	msg.from=session[:id]
  	msg.message=params[:message]
  	if msg.save
  		flash[:notice]="your message has been send"
  	else
  		flash[:error]="can't send the message"
  	end
  	redirect_to :back
  end
  def creat
    user=User.new(user_params)  
     if user.save
       redirect_to user_index_path
       session[:id]=user.id
     else
       redirect_to :back
     end
  end
  def sign_out
    user=User.find_by_id(session[:id])
    user.login=0
    user.save
    session[:id]=nil
    flash[:error]="You are successfully logged out"
    redirect_to root_url
  end
  def sign_in
    user=User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:id]=user.id
      user=User.find_by_id(session[:id])
      user.login=1
      user.save
      flash[:notice]="Welcome #{user.username}"
      redirect_to user_index_path
    else
      flash[:error]="Invalid credentials"
      redirect_to root_url and return
    end
  end
  def clear
    Message.destroy_all
    redirect_to :back
  end
  private
   def user_params
     params.require(:user).permit(:name,:username,:password,:password_confirmation,:email,:phone,:login)
   end
end
