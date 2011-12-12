class User < OmniAuth::Identity::Models::ActiveRecord
  has_many :memberships
  has_many :projects, :through => :memberships
  has_many :invitations
  has_many :mood_updates
  
  validates :email, :password, :password_confirmation, :presence =>true
  
  validates :email, :uniqueness=>true, :if => Proc.new{|i| i.email.present?}
                    
  validates  :password, :length => { :minimum => 5, :maximum => 40 },
                        :confirmation =>true,
                        :if => Proc.new{|i| i.password.present?}
                    
  def self.find_from_hash(auth_hash)
    where(:id => auth_hash['uid']).first
  end
  
  def token=(code)
    setup_from_invitation(Invitation.for_token(code))
  end
  
  def setup_from_invitation(invitation)
    if invitation
      self.email ||= invitation.recipient_email
      self.join(invitation.project)
    end
  end
  
  def join(project)
    projects << project
  end
  
  def member_of?(project)
    projects.select{ |p| p == project }.any?
  end
  
  def invite(email)
    invitations.new(:recipient_email => email)
  end
  
end
