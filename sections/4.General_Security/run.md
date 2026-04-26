ansible-playbook -i inventory.ini section.yml -K -e "mysql_pass=MatKhau@123" 

### 
# -i inventory.ini: Cờ -i là viết tắt của inventory (danh sách tài sản/máy chủ). Đoạn này chỉ định cho Ansible biết phải đọc file inventory.ini để tìm danh sách các địa chỉ IP hoặc máy chủ mục tiêu mà nó cần kết nối đến để chạy kịch bản.

# -section.yml: Đây là tên của file playbook chính. Nó đóng vai trò là bản thiết kế chứa tất cả các nhiệm vụ (tasks) cần thực hiện.

# -K (viết hoa): Tương đương với cờ --ask-become-pass. Vì trong các file cấu hình có khai báo become: true (yêu cầu quyền root để chỉnh sửa file hệ thống /etc/mysql/... hoặc khởi động lại dịch vụ), cờ -K sẽ buộc Ansible dừng lại một nhịp ở đầu chương trình để hỏi bạn nhập mật khẩu sudo của máy chủ một cách an toàn (ẩn ký tự).

# -e "mysql_pass=MatKhau@123": Cờ -e là viết tắt của extra variables (biến bổ sung/biến ngoại lai). Đoạn này cho phép bạn truyền trực tiếp một biến có tên là mysql_pass với giá trị là MatKhau@123 vào trong playbook ngay lúc chạy. Tác dụng: Bất kỳ chỗ nào trong file .yml của bạn gọi {{ mysql_pass }}, nó sẽ nhận giá trị này. Đặc biệt, biến truyền từ -e có độ ưu tiên cao nhất, nó sẽ ghi đè (override) mọi giá trị mysql_pass đang được viết sẵn bên trong file .yml. 
###
