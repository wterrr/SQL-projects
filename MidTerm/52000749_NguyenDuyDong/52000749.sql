use master;
go
alter database QUANLYCHVLXD set single_user with rollback immediate

drop database QUANLYCHVLXD

create database QUANLYCHVLXD
go

use QUANLYCHVLXD
go

-- Câu 1
if exists (select * from sysobjects where name = 'LoaiVatTu')
	drop table LoaiVatTu
go

create table LoaiVatTu (
	MaLoai char(10) not null,
	TenLoai nvarchar(100) not null,
	primary key(MaLoai)
)
go

if exists (select * from sysobjects where name = 'VatTu')
	drop table VatTu
go

create table VatTu (
	MaHang char(10) not null,
	TenHang nvarchar(100) not null,
	DonViTinh nvarchar(10) default N'cái',
	SoLuong int not null,
	DonGia int not null,
	MaLoai char(10) not null,
	primary key(MaHang),
	check(SoLuong > 0 and DonGia > 0)
)

alter table VatTu add constraint fk_VatTu_MaLoai foreign key(MaLoai) references LoaiVatTu(MaLoai)
go

if exists (select * from sysobjects where name = 'KhachHang')
	drop table KhachHang
go

create table KhachHang (
	MaSoKH char(10) not null,
	TenKH nvarchar(20) not null,
	DienThoai char(20) not null,
	primary key(MaSoKH)
)
go

if exists (select * from sysobjects where name = 'HoaDon')
	drop table HoaDon
go

create table HoaDon (
	SoHoaDon char(10) not null,
	NgayLap datetime not null,
	MaSoKH char(10) not null,
	primary key(SoHoaDon)
)
alter table HoaDon add constraint fk_HoaDon_MaSoKH foreign key(MaSoKH) references KhachHang(MaSoKH)
go

if exists (select * from sysobjects where name = 'ChiTietHD')
	drop table ChiTietHD
go

create table ChiTietHD (
	SoHoaDon char(10) not null,
	MaHang char(10) not null,
	SoLuong int not null,
	DonGia int not null,
	check(SoLuong > 0 and DonGia > 0)
)

-- Câu 2
-- câu a
alter table ChiTietHD add constraint pk_ChiTietHD primary key(SoHoaDon,MaHang)
alter table ChiTietHD add constraint fk_ChiTietHD_SoHoaDon foreign key(SoHoaDon) references HoaDon(SoHoaDon)
alter table ChiTietHD add constraint fk_ChiTietHD_MaHang foreign key(MaHang) references VatTu(MaHang)
go

-- câu b
alter table KhachHang
alter column TenKH nvarchar(50)

-- Câu 3
insert into LoaiVatTu values('D', N'Đá xây dựng'),
('XM', N'Xi măng'),
('C', N'Cát xây dựng'),
('G', N'Gạch'),
('T', N'Thép')

insert into VatTu values('d01', N'đá mi bụi', N'khối', 100, 1000000, 'D'),
('d02', N'đá mi sàng', N'khối', 100, 150000, 'D'),
('x01', N'xi măng vissai pcb40', N'thùng', 50, 100000, 'XM'),
('x02', N'xi măng Vissai pcb30', N'thùng', 50, 50000, 'XM'),
('c01', N'cát san lấp', N'thùng', 100, 55000, 'C'),
('c02', N'cát xây lô', N'thùng', 100, 65000, 'C'),
('g01', N'gạch block', N'khối', 200, 100000, 'G'),
('g02', N'gạch An Bình', N'khối', 200, 125000, 'G'),
('t01', N'thép cuộn 6', N'cái',150, 150000, 'T'),
('t02', N'thép cuộn 8', N'cái',150, 175000, 'T')

insert into KhachHang values('KH001', N'Nguyễn Duy Đông', '0943542142'),
('KH002', N'Lê Văn Việt', '0957384721'),
('KH003', N'Huỳnh Đình Long', '0936582462'),
('KH004', N'Trần Hợp Kiên', '092646242'),
('KH005', N'Thái Lê Vân', '034736163')

set dateformat dmy
insert into HoaDon values('HD001', '19/1/2022', 'KH001'),
('HD002', '9/12/2022', 'KH001'),
('HD003', '6/1/2022', 'KH001'),
('HD004', '20/12/2021', 'KH002'),
('HD005', '2/6/2021', 'KH002'),
('HD006', '7/4/2021', 'KH003'),
('HD007', '18/11/2021', 'KH003'),
('HD008', '3/10/2021', 'KH003'),
('HD009', '26/6/2021', 'KH003'),
('HD0010', '18/8/2022', 'KH004'),
('HD0011', '12/8/2022', 'KH004'),
('HD0012', '10/1/2022', 'KH004'),
('HD0013', '1/8/2022', 'KH004'),
('HD0014', '7/1/2020', 'KH005')

insert into ChiTietHD values('HD001', 'd02', 50, 7500000),
('HD002', 'c01', 50, 2750000),
('HD003', 't02', 50, 8750000),
('HD004', 'x01', 20, 2000000),
('HD005', 'c02', 20, 1300000),
('HD006', 'c01', 50, 2750000),
('HD007', 'd02', 50, 7500000),
('HD008', 't01', 50, 7500000),
('HD009', 'g02', 100, 12500000),
('HD0010', 'g02', 100, 12500000),
('HD0011', 'd01', 100, 10000000),
('HD0012', 't01', 50, 7500000),
('HD0013', 'c02', 100, 5500000),
('HD0014', 't01', 100, 15000000)
-- Câu 4
-- câu a
select TenHang, SoLuong, DonViTinh
from VatTu
where SoLuong >= 10 and DonViTinh = N'thùng'

-- câu b
select kh.MaSoKH, TenKH, count(kh.MaSoKH) N'Số Lần Mua Hàng'
from KhachHang kh inner join HoaDon hd on kh.MaSoKH = hd.MaSoKH
group by kh.MaSoKH, TenKH

-- câu c
select kh.MaSoKH, TenKH, count(kh.MaSoKH) N'Số lần mua'
from KhachHang kh inner join HoaDon hd on kh.MaSoKH = hd.MaSoKH
group by kh.MaSoKH, TenKH
having count(kh.MaSoKH) >= all (select count(kh.MaSoKH) N'Số lần mua'
								from KhachHang kh inner join HoaDon hd on kh.MaSoKH = hd.MaSoKH
								group by kh.MaSoKH, TenKH)
select kh.MaSoKH, TenKH, sum(ct.DonGia) N'Tổng Giá Trị'
from KhachHang kh, HoaDon hd, ChiTietHD ct
where kh.MaSoKH = hd.MaSoKH and ct.SoHoaDon = hd.SoHoaDon
group by kh.MaSoKH, TenKH
having sum(ct.DonGia) >= all (select sum(ct.DonGia) N'Tổng Giá Trị'
								from KhachHang kh, HoaDon hd, ChiTietHD ct
								where kh.MaSoKH = hd.MaSoKH and ct.SoHoaDon = hd.SoHoaDon
								group by kh.MaSoKH, TenKH)

-- câu 5
-- câu a
go
create function cauA(@s nvarchar(50))
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
					set @result = @result + upper(substring(@s, @i, 1))
					set @i = @i + 1
				end
			else if (substring(@s, @i-1, 1) = ' ' and @i+1 <> len(@s))
				begin
					set @result = @result + upper(substring(@s, @i, 1))
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

select dbo.cauA(MaHang) as MaHang, dbo.cauA(TenHang) as TenHang, DonViTinh, SoLuong, DonGia, MaLoai
from VatTu
drop function cauA

-- câu b

go
create function cauB(@makh char(10))
returns int
as
begin
	declare @c int
	select @c = count(@makh)
	from HoaDon
	where HoaDon.MaSoKH = @makh
	return @c
end

go
select distinct KhachHang.MaSoKH, TenKH, dbo.cauB(KhachHang.MaSoKH) as SoLanMua
from KhachHang, HoaDon
where KhachHang.MaSoKH = HoaDon.MaSoKH
drop function dbo.cauB

-- câu 6
-- câu a
go
create proc Cau6a @mahang char(10), @tenhang nvarchar(100), @donvitinh nvarchar(10), @soluong int, @dongia int, @maloai char(10)
as
begin
	if @mahang is null or exists (select MaHang from Vattu where MaHang = @mahang)
		print N'Khóa chính không được phép trùng, vui lòng nhập lại'
	else if @maloai is null or not exists (select MaLoai from LoaiVattu where MaLoai = @Maloai)
		print N'Khóa ngoại không được phép rỗng, vui lòng nhập lại'
	else if @donvitinh is null or not exists (select DonViTinh from VatTu where DonViTinh = @donvitinh)
		print(N'Vui lòng nhập lại đơn vị tính')
	else if @soluong <=0 
		print N'Số lượng phải lớn hơn 0, vui lòng nhập lại'
	else if @dongia <=0
		print N'Đơn giá phải lớn hơn 0, vui lòng nhập lại'
	
	insert into VatTu values(@mahang, @tenhang, @donvitinh, @soluong, @dongia, @maloai)
end

--thực thi
go
exec dbo.Cau6a'd03', N'đá hoa cương', N'khối', 40, 200000, 'D'


--6b
go
create proc Cau6b @Sohoadon char(15), @Ngaylap datetime, @MasoKH char(15)
as
begin 
	if @Sohoadon is null or exists (select SoHoaDon from HoaDon where SoHoaDon = @Sohoadon)
		print N'Khóa chính không được trùng, vui lòng nhập lại'
	else if @MasoKH is null or not exists (select MasoKH from Khachhang where MasoKH = @MasoKH)
		print N'Khóa ngoại không được rỗng, vui lòng nhập lại'
	
	insert into Hoadon values(@Sohoadon, @Ngaylap, @MasoKH)
end

go
exec dbo.Cau6b'HD0015', "2/3/2022", 'KH003'

-- câu 7
-- a
go
create trigger cau7A
	on KhachHang
	instead of insert
as
	declare @ms char(10)
	set @ms = (select MaSoKH from inserted)
	declare @dt char(20)
	set @dt = (select DienThoai from inserted)
	declare @t nvarchar(50)
	set @t = (select TenKH from inserted)
	if @ms = '' or exists (select MaSoKH from KhachHang where MaSoKH = @ms)
		begin
			print N'Không thỏa điều kiện, xin nhập lại'
			RollBack Tran
		end
	else if exists (select DienThoai from KhachHang where DienThoai = @dt)
		begin
			print N'Số Điện Thoại này đã tồn tại - Khách hàng này đã tồn tại'
			RollBack Tran
		end
	else
		begin
			insert into KhachHang values(@ms, @t, @dt)
		end
go

insert into KhachHang values('KH006', N'Nguyễn Văn A', '095038573')
drop trigger cau7A
go

-- b
create trigger Cau7b
on Khachhang
instead of update
as
begin
	
	declare 
	@Maso_n char(15), -- mã số mới
	@Maso_o char(15),  -- mã số cũ
	@TenKH nvarchar(30),
	@SDT char(20)

	set @Maso_n = (select MaSoKH from inserted)
	set @Maso_o = (select MaSoKH from deleted)
	set @TenKH = (select TenKH from inserted)
	set @SDT = (select Dienthoai from inserted)
	if @Maso_n = '' or exists (select MasoKH from Khachhang where MasoKH = @Maso_n)
	begin
		print N'Khóa chính không được trùng hoặc rỗng, vui lòng nhập lại'
		Rollback Tran
	end

	else if @Maso_n = @Maso_o or exists (select MasoKH from Khachhang)
	begin
		print N'Bạn không được phép sửa khóa chính'
		Rollback Tran
	end
	else	
		update Khachhang
		set MasoKH = @Maso_n
		where MasoKH = @Maso_o

end