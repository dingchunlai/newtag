class ZhuanquSort < ActiveRecord::Base

  acts_as_readonlyable [:read_only_51hejia] unless RAILS_ENV == "test"

  class << self

    def get_sort_id_by_sort_name(sort_name)
      kw_mc = "sort_id_by_sort_name_#{sort_name}"
      return get_mc(kw_mc, 0, 500) do
        self.find(:first, :select=>"id", :conditions=>"is_delete = 0 and sort_name = '#{sort_name}'")["id"] rescue 0
      end
    end

    def get_sorts_by_board_id(board_id)
      kw = get_key("sorts_by_board_id", board_id)
      return get_memcache(kw, 2.days) do
        board_id = board_id.to_i
        conditions = []
        conditions << "is_delete = 0 and is_published = 1"
        if board_id == 1
          conditions << "(board_id in (1,6))"
        else
          conditions << "board_id = #{board_id}"
        end
        ZhuanquSort.find(:all,:select=>"id, sort_name",:conditions=>conditions.join(" and "))
      end
    end

  end

  def board
    ZHUANQU_BOARD_SPELL[board_id.to_i]
  end

end
