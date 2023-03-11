use master;
go
alter database CuaHangCD set single_user with rollback immediate

drop database CuaHangCD

create database CuaHangCD
go

use CuaHangCD
go

CREATE TABLE NhaSanXuat
(
  TenNSX nvarchar(100) NOT NULL,
  QuocTich nvarchar(50) NOT NULL,
  DiaChi nvarchar(100) NOT NULL,
  PRIMARY KEY (TenNSX)
);

CREATE TABLE BaiHat
(
  TenBaiHat nvarchar(100) NOT NULL,
  TenNhacSi nvarchar(500) NOT NULL,
  TenCaSi nvarchar(50) NOT NULL,
  PRIMARY KEY (TenBaiHat)
);

CREATE TABLE TheLoai
(
  MaTheLoai CHAR(10) NOT NULL,
  TenTheLoai nvarchar(100) NOT NULL,
  PRIMARY KEY (MaTheLoai)
);

CREATE TABLE KhachHang
(
  CMND CHAR(10) NOT NULL,
  TenKH nvarchar(50) NOT NULL,
  DiaChi nvarchar(100) NOT NULL,
  Phai INT NOT NULL,
  MaKH CHAR(100) NOT NULL,
  PRIMARY KEY (MaKH)
);

CREATE TABLE CuaHang
(
  MaSoThue CHAR(10) NOT NULL,
  SDT CHAR(15) NOT NULL,
  DiaChi nvarchar(50) NOT NULL,
  PRIMARY KEY (MaSoThue)
);

CREATE TABLE Phim
(
  NamSanXuat INT NOT NULL,
  TenDienVienChinh nvarchar(50) NOT NULL,
  TenDaoDien nvarchar(50) NOT NULL,
  TenPhim nvarchar(100) NOT NULL,
  MaTheLoai CHAR(10) NOT NULL,
  PRIMARY KEY (TenPhim),
  FOREIGN KEY (MaTheLoai) REFERENCES TheLoai(MaTheLoai)
);

CREATE TABLE HoaDon
(
  TenKH nvarchar(50) NOT NULL,
  NgayLap DATE NOT NULL,
  MaHoaDon CHAR(10) NOT NULL,
  TenDiaHinh nvarchar(100),
  TenDiaNhac nvarchar(100),
  GiaTien int NOT NULL,
  MaKH CHAR(100) NOT NULL,
  PRIMARY KEY (MaHoaDon),
  FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE CDHinh
(
  DonGia INT NOT NULL,
  TenDiaHinh nvarchar(100) NOT NULL,
  SoLuong INT NOT NULL,
  TenPhim nvarchar(100) NOT NULL,
  TenNSX nvarchar(100) NOT NULL,
  MaSoThue CHAR(10) NOT NULL,
  MaHoaDon CHAR(10) NOT NULL,
  PRIMARY KEY (TenDiaHinh),
  FOREIGN KEY (TenPhim) REFERENCES Phim(TenPhim),
  FOREIGN KEY (TenNSX) REFERENCES NhaSanXuat(TenNSX),
  FOREIGN KEY (MaSoThue) REFERENCES CuaHang(MaSoThue),
  FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon)
);

CREATE TABLE CDNhac
(
  TenDiaNhac nvarchar(100) NOT NULL,
  DonGia INT NOT NULL,
  Album nvarchar(100) NOT NULL,
  SoLuong INT NOT NULL,
  MaSoThue CHAR(10) NOT NULL,
  TenNSX nvarchar(100) NOT NULL,
  MaHoaDon CHAR(10) NOT NULL,
  PRIMARY KEY (TenDiaNhac),
  FOREIGN KEY (MaSoThue) REFERENCES CuaHang(MaSoThue),
  FOREIGN KEY (TenNSX) REFERENCES NhaSanXuat(TenNSX),
  FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon)
);

CREATE TABLE Chua
(
  TenDiaNhac nvarchar(100) NOT NULL,
  TenBaiHat nvarchar(100) NOT NULL,
  PRIMARY KEY (TenDiaNhac, TenBaiHat),
  FOREIGN KEY (TenDiaNhac) REFERENCES CDNhac(TenDiaNhac),
  FOREIGN KEY (TenBaiHat) REFERENCES BaiHat(TenBaiHat)
);

-- insert
insert into NhaSanXuat values('Gore Verbinski', N'Mỹ', N'Mỹ'),
(N'Thu Trang', N'Việt Nam', N'Hồ Chí Minh'),
(N'Hoàng Dũng', N'Việt Nam', N'Hồ Chí Minh'),
(N'Chilles', N'Việt Nam', N'Hồ Chí Minh')

insert into BaiHat values(N'Qua Khung Cửa Sổ', N'Chilles', N'Chilles'),
(N'Nàng Thơ', N'Hoàng Dũng', N'Hoàng Dũng')

insert into TheLoai values('KD', N'Kinh Dị'),
('H', 'Hài')

insert into KhachHang values('221542238', N'Nguyễn Duy Đông', N'Phú Yên', 0, 'KH001'),
('221542239', N'Lê Văn Việt', N'Thanh Hóa', 0, 'KH002'),
('221542240', N'Huỳnh Đình Long', N'Quảng Nam', 0, 'KH003'),
('221542241', N'Trần Hợp Kiên', N'Thanh Hóa', 0, 'KH004'),
('221542242', N'Thái Lê Vân', N'Quảng Nam', 1, 'KH005')

insert into CuaHang values('190902', '0369573202', N'Hồ Chí Minh')

insert into Phim values(2021, N'Thu Trang', N'Thu Trang', N'Nghề Siêu Dễ', 'H'),
(2002, 'Naomi Watts', 'Gore Verbinski', 'The Ring', 'KD')

set dateformat dmy
insert into HoaDon values(N'Nguyễn Duy Đông', '19/01/2021', 'HD001', N'The Ring', N'Nàng Thơ', 270000,'KH001'),
(N'Lê Văn Việt', '20/01/2021', 'HD002', null, N'Qua Khung Cửa Sổ', 50000,'KH002'),
(N'Huỳnh Đình Long', '9/02/2021', 'HD003', N'Nghề Siêu Dễ', N'null', 180000,'KH003'),
(N'Trần Hợp Kiên', '1/01/2021', 'HD004', N'The Ring', null, 180000,'KH004'),
(N'Thái Lê Vân', '16/04/2021', 'HD005', N'The Ring', N'Qua Khung Cửa Sổ', 230000,'KH005')

insert into CDHinh values(150000, N'Phim Kinh Dị', 1000, 'The Ring', 'Gore Verbinski', '190902', 'HD004'),
(100000, N'Phim Hài', 1000, N'Nghề Siêu Dễ', N'Thu Trang', '190902', 'HD003')

insert into CDNhac values(N'Nàng Thơ', 80000, 'Album 25', 1000, '190902', N'Hoàng Dũng', 'HD001'),
(N'Qua Khung Cửa Sổ', 50000, N'Qua Khung Cửa Sổ', 1000, '190902', N'Chilles', 'HD005')

insert into Chua values(N'Nàng Thơ', N'Nàng Thơ'),
(N'Qua Khung Cửa Sổ', N'Qua Khung Cửa Sổ')

-- Truy vấn cơ bản
--Đĩa nhạc có giá lớn hơn 50000
select * from CDNhac where DonGia > 50000

-- Tên Đĩa nhạc trong Album 25
select TenDiaNhac from CDNhac where Album = N'Album 25'

-- Hóa đơn có cả đỉa nhạc và hình
select * from HoaDon where TenDiaHinh is not null and TenDiaNhac is not null

-- Truy vấn nâng cao
-- Sắp xếp giá trị hóa đơn
select * from HoaDon order by GiaTien desc

-- Khách Hàng Nam có Hóa đơn có đơn giá cao nhất
select HoaDon.TenKH, MaHoaDon, TenDiaHinh, TenDiaNhac, MAX(GiaTien) as N'Đơn Giá'
from HoaDon, KhachHang
where HoaDon.MaKH = KhachHang.MaKH and Phai = 0
group by HoaDon.TenKH, MaHoaDon, TenDiaHinh, TenDiaNhac
having max(GiaTien) >= all (select MAX(GiaTien) as N'Đơn Giá'
							from HoaDon, KhachHang
							where HoaDon.MaKH = KhachHang.MaKH and Phai = 0
							group by HoaDon.TenKH, MaHoaDon, TenDiaHinh, TenDiaNhac
							)

-- Function hiển thị tên Đĩa nhạc viết thường
go 
create function vietThuong(@s nvarchar(50))
returns nvarchar(50)
as 
begin
	declare @i int
	set @i = 1
	declare @result nvarchar(50)
	set @result = ''
	declare @l int
	while (@i < len(@s)+1)
		begin
			if (@i = 1)
				begin
					set @result = @result + lower(substring(@s, @i, 1))
					set @i = @i + 1
				end
			else if (substring(@s, @i-1, 1) = ' ' and @i+1 <> len(@s))
				begin
					set @result = @result + lower(substring(@s, @i, 1))
					set @i =@i + 1
				end
			else
				begin
					set @result = @result + lower(substring(@s, @i, 1))
					set @i = @i + 1
				end
			end
	return @result
end
go
select dbo.vietThuong(TenDiaNhac) as N'Tên Đĩa Nhạc'
from CDNhac
drop function vietThuong

-- Procedure tạo hóa đơn mới
go
create proc taoHoaDon @tenKH nvarchar(50), @ngaylap date, @maHD char(10), @tenDiaHinh nvarchar(100), @tenDiaNhac nvarchar(100), @giaTien int, @maKH char(10)
as
	begin
		if @maHD is null
			print(N'Mã hóa đơn không được để trống.')
		else if @maHD is not null and exists (select MaHoaDon from HoaDon where MaHoaDon = @maHD)
			print(N'Mã hóa đơn không được trùng.')
		else if @maKH is null
			print(N'Mã khách hàng không được để trống.')
		else if @maKH is not null and @maKH not in (select MaKH from KhachHang where MaKH = @maKH)
			print(N'Mã khách hàng không tồn tại.')
		else if @maKH is not null and @tenKH is not null and not exists (select MaKH, TenKH from KhachHang where MaKH = @maKH and TenKH = @tenKH)
			print(N'Tên khách hàng không khớp với mã khách hàng')
		else if @tenDiaHinh is not null and @tenDiaHinh not in (select TenDiaHinh from CDHinh)
			print(N'Đĩa hình không tồn tại.')
		else if @tenDiaNhac is not null and @tenDiaNhac not in (select TenDiaNhac from CDNhac)
			print(N'Đĩa nhạc không tồn tại.')
		else
			insert into HoaDon values (@tenKH, @ngaylap, @maHD, @tenDiaHinh, @tenDiaNhac, @giaTien, @maKH)
	end
go

-- Thực thi
exec dbo.taoHoaDon N'Nguyễn Duy Đông', '5/5/2021', 'HD006', null, N'Nàng Thơ', 50000, 'KH001'

-- Trigger thêm khách hàng có kiểm tra khóa chính, và số CMND không được trùng
go
create trigger themKhachHang
	on KhachHang
	instead of insert
as
	declare @cmnd char(10)
	set @cmnd = (select CMND from inserted)
	declare @tenKH nvarchar(50)
	set @tenKH = (select TenKH from inserted)
	declare @dc nvarchar(100)
	set @dc = (select DiaChi from inserted)
	declare @phai int
	set @phai = (select Phai from inserted)
	declare @makh char(10)
	set @makh = (select MaKH from inserted)
	if @makh = '' or exists (select MaKH from KhachHang where MaKH = @makh)
		begin
			print N'Không thỏa điều kiện, xin nhập lại'
			RollBack Tran
		end
	else if exists (select CMND from KhachHang where CMND = @cmnd)
		begin
			print N'Số CMND này đã tồn tại - Khách hàng này đã tồn tại'
			RollBack Tran
		end
	else
		begin
			insert into KhachHang values(@cmnd, @tenKH, @dc, @phai, @makh)
		end
go

insert into KhachHang values('221542243', N'Lềnh Gia Hân', N'Phú Yên', 1, 'KH006')
drop trigger themKhachHang
go

