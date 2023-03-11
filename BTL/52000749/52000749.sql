-- Câu 3
-- a. Tạo database
use master
go
if exists(select * from sysdatabases where NAME = 'QUANLYSIEUTHI')
	DROP DATABASE QUANLYSIEUTHI
go
create database QUANLYSIEUTHI
go

use QUANLYSIEUTHI
go


-- b. Tạo các bảng dữ liệu
CREATE TABLE NhaSX
(
  MaNSX CHAR(10) NOT NULL,
  TenNSX NVARCHAR(50) NOT NULL,
  QuocTich NVARCHAR(20) NOT NULL,
  PRIMARY KEY (MaNSX)
);

CREATE TABLE NhaCungCap
(
  HoTen NVARCHAR(50) NOT NULL,
  MaNCC CHAR(10) NOT NULL,
  DiaChi NVARCHAR(100) NOT NULL,
  PRIMARY KEY (MaNCC)
);

CREATE TABLE QuayHang
(
  SoQuay INT NOT NULL,
  TenQuay NVARCHAR(50) NOT NULL,
  ViTri NVARCHAR(50) NOT NULL,
  PRIMARY KEY (SoQuay)
);

CREATE TABLE KhachHang
(
  DiaChi NVARCHAR(100) NOT NULL,
  TenKH NVARCHAR(50) NOT NULL,
  MaKH CHAR(10) NOT NULL,
  PRIMARY KEY (MaKH)
);

CREATE TABLE MatHang
(
  MaHang CHAR(10) NOT NULL,
  SoLuong INT NOT NULL,
  DonGia INT NOT NULL,
  DVT NVARCHAR(10) NOT NULL,
  TenHang NVARCHAR(50) NOT NULL,
  MaNSX CHAR(10) NOT NULL,
  SoQuay INT NOT NULL,
  MaNCC CHAR(10) NOT NULL,
  PRIMARY KEY (MaHang),
  FOREIGN KEY (MaNSX) REFERENCES NhaSX(MaNSX),
  FOREIGN KEY (SoQuay) REFERENCES QuayHang(SoQuay),
  FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);

CREATE TABLE PhieuNhapHang
(
  MaPH CHAR(10) NOT NULL,
  NgayNhap DATE NOT NULL,
  SoLuong INT NOT NULL,
  DonGia INT NOT NULL,
  MaNCC CHAR(10) NOT NULL,
  MaHang CHAR(10) NOT NULL,
  PRIMARY KEY (MaPH, MaNCC, MaHang),
  FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),
  FOREIGN KEY (MaHang) REFERENCES MatHang(MaHang)
);

CREATE TABLE PhieuBanHang
(
  MaPhieuBan CHAR(10) NOT NULL,
  SoLuong INT NOT NULL,
  DonGia INT NOT NULL,
  MaHang CHAR(10) NOT NULL,
  MaKH CHAR(10) NOT NULL,
  PRIMARY KEY (MaPhieuBan, MaHang),
  FOREIGN KEY (MaHang) REFERENCES MatHang(MaHang),
  FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Thêm dữ liệu
insert into NhaSX values('PS', N'PepsiCo', N'Hoa Kỳ'),
('CCCL', N'Coca Cola Company', N'Hoa Kỳ'),
('KT', 'Tri-Sum', N'Anh'),
('XX', 'BGI', N'Việt Nam'),
('MD', 'PepsiCo', N'Hoa Kỳ'),
('SP', 'PepsiCo', N'Hoa Kỳ'),
('HK', 'Heineken', N'Việt Nam'),
('TG', 'Tiger', N'Việt Nam'),
('STT', 'Masan', N'Việt Nam'),
('SG', 'SABECO', N'Việt Nam')

insert into NhaCungCap values('PepSi', 'NCC001', N'Hoa Kỳ'),
('Coca Cola', 'NCC002', N'Hoa Kỳ'),
('Trisum', 'NCC003', N'Anh'),
('BGI', 'NCC004', N'Việt Nam'),
('Mirinda', 'NCC005', N'Hoa Kỳ'),
('Sprite', 'NCC006', N'Hoa Kỳ'),
(N'Bia Heineken', 'NCC007', N'Việt Nam'),
(N'Bia Tiger', 'NCC008', N'Việt Nam'),
(N'Bia Sư Tử Trắng', 'NCC009', N'Việt Nam'),
(N'Bia Sài Gòn', N'NCC010', N'Việt Nam')

insert into QuayHang values(1, N'Pepsi', N'Nước Ngọt'),
(2, N'Coca Cola', N'Nước Ngọt'),
(3, N'Snack Khoai Tây', N'Snack'),
(4, N'Xá Xị', N'Nước Ngọt'),
(5, 'Mirinda', N'Nước Ngọt'),
(6, 'Sprite', N'Nước Ngọt'),
(7, N'Bia Heineken', N'Bia'),
(8, N'Bia Tiger', N'Bia'),
(9, N'Bia Sư Tử Trắng', N'Bia'),
(10, N'Bia Sài Gòn', N'Bia')

insert into KhachHang values(N'Phú Yên', N'Nguyễn Duy Đông', 'KH001'),
(N'Thanh Hóa', N'Lê Văn Việt', 'KH002'),
(N'Thanh Hóa', N'Trần Hợp Kiên', 'KH003'),
(N'Quảng Nam', N'Huỳnh Đình Long', 'KH004'),
(N'Quảng Nam', N'Thái Lê Vân', 'KH005'),
(N'Lâm Đồng', N'Phan Thanh Trúc', 'KH006'),
(N'Phú Yên', N'Phạm Huỳnh Ánh Vi', 'KH007'),
(N'Phú Yên', N'Võ Thị Xuân', 'KH008'),
(N'Phú Yên', N'Nguyễn Hồng Thư', 'KH009'),
(N'Bến Tre', N'Trần Lê Minh Trí', 'KH010')

insert into MatHang values('NN-PS', 550, 10000, 'Lon', 'Pepsi', 'PS', 1, 'NCC001'),
('NN-CCCL', 200, 10000, 'Lon', 'Coca Cola', 'CCCL', 2, 'NCC002'),
('SN-KT', 150, 8000, N'Bịch', N'Snack Khoai Tây', 'KT', 3, 'NCC003'),
('NN-XX', 250, 10000, 'Lon', N'Xá Xị', 'XX', 4, 'NCC004'),
('NN-MD', 50, 10000, 'Lon', 'Mirinda', 'MD', 5, 'NCC005'),
('NN-SP', 250, 10000, 'Lon', 'Sprite', 'SP', 6, 'NCC006'),
('B-HK', 230, 20000, 'Lon', N'Bia Heineken', 'HK', 7, 'NCC007'),
('B-TG', 200, 15000, 'Lon', N'Bia Tiger', 'TG', 8, 'NCC008'),
('B-STT', 200, 15000, 'Lon', N'Bia Sư Tử Trắng', 'STT', 9, 'NCC009'),
('B-SG', 50, 15000, 'Lon', N'Bia Sài Gòn', 'SG', 10, 'NCC010')

set dateformat dmy
insert into PhieuNhapHang values('PNH001', '19/9/2021', 100, 1000000, 'NCC001', 'NN-PS'),
('PNH001', '1/9/2021', 150, 1500000, 'NCC001', 'NN-XX'),
('PNH002', '2/9/2022', 100, 1000000, 'NCC002', 'NN-CCCL'),
('PNH002', '7/5/2022', 50, 500000, 'NCC002', 'SN-KT'),
('PNH002', '2/9/2022', 100, 1000000, 'NCC002', 'NN-PS'),
('PNH003', '4/3/2022', 100, 800000, 'NCC003', 'SN-KT'),
('PNH004', '25/12/2021', 100, 1000000, 'NCC004', 'NN-XX'),
('PNH004', '2/1/2021', 100, 2000000, 'NCC004', 'B-HK'),
('PNH005', '2/3/2022', 50, 500000, 'NCC005', 'NN-MD'),
('PNH005', '4/3/2022', 50, 500000, 'NCC005', 'NN-SP'),
('PNH005', '5/3/2022', 100, 1000000, 'NCC005', 'NN-CCCL'),
('PNH005', '1/3/2022', 150, 1500000, 'NCC005', 'NN-PS'),
('PNH006', '19/4/2022', 200, 2000000, 'NCC006', 'NN-SP'),
('PNH006', '3/4/2022', 80, 1200000, 'NCC006', 'B-TG'),
('PNH007', '1/1/2022', 60, 1200000, 'NCC007', 'B-HK'),
('PNH007', '1/2/2022', 70, 1050000, 'NCC007', 'B-TG'),
('PNH008', '2/1/2022', 100, 1000000, 'NCC008', 'NN-PS'),
('PNH008', '21/1/2022', 50, 750000, 'NCC008', 'B-TG'),
('PNH008', '21/2/2022', 100, 1500000, 'NCC008', 'B-STT'),
('PNH009', '10/9/2021', 100, 1500000, 'NCC009', 'B-STT'),
('PNH009', '10/12/2021', 70, 1400000, 'NCC009', 'B-HK'),
('PNH010', '15/5/2021', 50, 750000, 'NCC010', 'B-SG'),
('PNH010', '4/5/2021', 100, 1000000, 'NCC010', 'NN-PS')

insert into PhieuBanHang values('PBH001', 5, 50000, 'NN-PS', 'KH001'),
('PBH001', 5, 40000, 'SN-KT', 'KH001'),
('PBH002', 4, 40000, 'NN-CCCL', 'KH002'),
('PBH002', 2, 16000, 'SN-KT', 'KH002'),
('PBH003', 10, 100000, 'NN-XX', 'KH003'),
('PBH004', 2, 16000, 'SN-KT', 'KH004'),
('PBH004', 5, 75000, 'B-TG', 'KH004'),
('PBH004', 5, 50000, 'NN-MD', 'KH004'),
('PBH005', 10, 100000, 'NN-SP', 'KH005'),
('PBH005', 5, 40000, 'SN-KT', 'KH005'),
('PBH006', 5, 100000, 'B-HK', 'KH006'),
('PBH006', 10, 80000, 'SN-KT', 'KH006'),
('PBH007', 5, 50000, 'NN-PS', 'KH007'),
('PBH007', 5, 75000, 'B-SG', 'KH007'),
('PBH007', 5, 40000, 'SN-KT', 'KH007'),
('PBH007', 5, 75000, 'B-STT', 'KH007'),
('PBH008', 5, 50000, 'NN-PS', 'KH008'),
('PBH009', 4, 40000, 'NN-MD', 'KH009'),
('PBH010', 8, 80000, 'NN-SP', 'KH010'),
('PBH010', 10, 100000, 'NN-XX', 'KH010')

-- Câu 4
-- a. Tạo mới một phiếu nhập
go
create proc createPhieuNhap @maph char(10), @ngaynhap date, @sl int, @dongia int, @mancc char(10), @mahang char(10)
as
begin
	if @maph is null 
		print N'Khóa chính không được phép rỗng, vui lòng nhập lại'
	else if @maph is not null and exists (select MaPH from PhieuNhapHang where MaPH = @maph)
		print N'Khóa chính đã tồn tại, vui lòng nhập lại'
	else if @mancc is null
		print N'Mã nhà cung cấp không được phép rỗng, vui lòng nhập lại'
	else if @mancc is not null and @mancc not in (select MaNCC from NhaCungCap where MaNCC = @mancc)
		print N'Mã nhà cung cấp không tồn tại, vui lòng nhập lại'
	else if @mahang is null
		print N'Mã hàng không được phép rỗng, vui lòng nhập lại'
	else if @mahang is not null and @mahang not in (select MaHang from MatHang where MaHang = @mahang)
		print N'Mã hàng không tồn tại, vui lòng nhập lại'
	else 
		insert into PhieuNhapHang values(@maph, @ngaynhap, @sl, @dongia, @mancc, @mahang)
end
go

-- thực thi
exec dbo.createPhieuNhap 'PNH011', '2/9/2022', 100, 10000, 'NCC002', 'SN-CCCL'
go
drop proc createPhieuNhap
go

-- Câu 5
-- câu a. tổng tiền ứng với một phiếu nhập nào đó
go
create function tongTienPhieuNhap(@maph char(10))
returns int
as
begin
	return (select SUM(DonGia) from PhieuNhapHang where @maph = MaPH)
end
go
-- Thực thi
select distinct(MaPH), dbo.tongTienPhieuNhap(MaPH) as N'Tổng Tiền'
from PhieuNhapHang
where MaPH = 'PNH005'
drop function dbo.tongTienPhieuNhap

-- Câu 6
-- câu a. Cấp nhất số lượng khi đặt hàng
go
create trigger capNhatMatHang
on PhieuNhapHang
after insert
as
begin
	update MatHang
	set SoLuong = MatHang.SoLuong + (select SoLuong from inserted where MaHang = MatHang.MaHang), DonGia = inserted.DonGia
	from MatHang
	join inserted on MatHang.MaHang = inserted.MaHang
end
go
insert into PhieuNhapHang values('PNH012', '19/9/2021', 100, 15000, 'NCC001', 'NN-PS')


