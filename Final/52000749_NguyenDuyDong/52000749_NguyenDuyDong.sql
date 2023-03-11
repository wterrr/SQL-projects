-- Phần 1
-- Câu 1a
use master
go
if exists(select * from sysdatabases where NAME = 'QUANLYSANBONG')
	DROP DATABASE QUANLYSANBONG
go
create database QUANLYSANBONG
go

use QUANLYSANBONG
go

create table SanBong (
	MaSB char(10) not null,
	TenSB nvarchar(50) not null,
	LoaiSan nvarchar(20) not null,
	primary key (MaSB)
);

create table DichVu (
	MaDV char(10) not null,
	TenDichVu nvarchar(50),
	SoLuong int not null,
	DonGia int not null,
	primary key (MaDV)
);

create table GiaTienThueSan (
	MaGT char(10) not null,
	startAt time(0) not null,
	endAt time(0) not null,
	SoTien int not null,
	primary key (MaGT)
);

create table ThueSan (
	MaThueSan char(50) not null,
	SDTKH char(10) not null,
	MaSB char(10) not null,
	NgayThue date not null,
	GioBD time(0) not null,
	GioKetThuc time(0) not null,
	TongTien int not null,
	primary key (MaThueSan)
);

create table ChiTietThueSan (
	MaThueSan char(50) not null,
	MaDV char(10) not null,
	SoLuong int not null,
	DonGia int not null,
	primary key (MaThueSan, MaDV),
	foreign key (MaThueSan) references ThueSan(MaThueSan),
	foreign key (MaDV) references DichVu(MaDV)
);

insert into SanBong values ('SB001', N'Sân Bóng 1', N'Sân 5 người'),
('SB002', N'Sân Bóng 2', N'Sân 7 người'),
('SB003', N'Sân Bóng 3', N'Sân 11 người'),
('SB004', N'Sân Bóng 4', N'Sân 5 người'),
('SB005', N'Sân Bóng 5', N'Sân 11 người')

insert into DichVu values ('DV001', N'Thuê áo đấu', 100, 40000),
('DV002', N'Thuê giày đấu', 100, 50000),
('DV003', N'Nước uống', 100, 15000),
('DV004', N'Thức ăn', 100, 30000),
('DV005', N'Thuê tất', 100, 5000)

insert into GiaTienThueSan values ('GT001', '7:00:00', '9:00:00', 20000),
('GT002', '9:00:00', '11:00:00', 25000),
('GT003', '13:00:00', '15:00:00', 30000),
('GT004', '15:00:00', '17:00:00', 35000),
('GT005', '19:00:00', '21:00:00', 40000)

set dateformat dmy
insert into ThueSan values ('02032022001', '0369573202', 'SB001', '2/3/2022', '7:00:00', '9:00:00', 40000),
('04032022001', '0357340098', 'SB002', '4/3/2022', '9:00:00', '11:00:00', 50000),
('05032022001', '0357320943', 'SB003', '5/3/2022', '13:00:00', '15:00:00', 60000),
('06032022001', '0369343284', 'SB004', '6/3/2022', '15:00:00', '17:00:00', 70000),
('07032022001', '0369432498', 'SB005', '7/3/2022', '19:00:00', '21:00:00', 80000),
('07032022002', '0369432498', 'SB005', '7/3/2022', '7:00:00', '10:30:00', 90000),
('09032022001', '0357314832', 'SB005', '9/3/2022', '13:00:00', '16:30:00', 112500)

insert into ChiTietThueSan values ('02032022001', 'DV002', 2, 50000),
('04032022001', 'DV005', 10, 5000),
('05032022001', 'DV001', 5, 40000),
('06032022001', 'DV003', 20, 15000),
('07032022001', 'DV004', 20, 30000),
('09032022001', 'DV002', 5, 50000)

-- Câu 2
-- a. Hàm phát sinh mã số tự động
go
create function auto_id(@ngay date)
returns char(20)
as
begin
	declare @t varchar(20) = replace(CONVERT(varchar, @ngay, 112),'/','')
	declare @temp varchar(20) = substring(@t,7,2) + substring(@t,5,2) + substring(@t,1,4)
	declare @count int = (select count(NgayThue) from ThueSan where NgayThue = @ngay)
	declare @result char(20)
	if @count = 0
		set @result = @temp + '001'
	else
		if @count > 0 and @count < 9
			set @result = @temp + '00' +convert(char, @count + 1)
		else if @count >= 9
			set @result = @temp + '0' + convert(char, @count + 1)
		else if @count >= 99
			set @result = @temp + convert(char, @count + 1)
	return @result
end
go

-- thực thi
declare @t date = '9/3/2022'
declare @id char(20)= dbo.auto_id(@t)
select @id as AutoID
drop function dbo.auto_id

-- b. Hàm trả về số tiền thuê sân khi biết được giờ vào sân và giờ ra sân
go
create function getMoneyFromHour(@startAt time, @endAt time)
returns float
as
begin
	declare @result float
	declare @a time
	declare @b time
	declare @a1 float
	if @startAt < '9:00:00'
		begin
			if @endAt <= '9:00:00'    --7h đến 9h
				begin
					set @a = cast((cast(@endAt as datetime) - cast(@startAt as datetime)) as time)
					set @a1 = datepart(hour, @a) + datepart(minute, @a)/60.0
					set @result = @a1*20000
					return @result
				end
			else                     --7h đến 11h
				begin
					set @a = cast((cast('9:00:00' as datetime) - cast(@startAt as datetime)) as time)
					set @b = cast((cast(@endAt as datetime) - cast('9:00:00' as datetime)) as time)
					declare @c float = datepart(hour, @a) + datepart(minute, @a)/60.0
					declare @c1 float = datepart(hour, @b) + datepart(minute, @b)/60.0
					set @result = @c*20000 + @c1*25000
					return @result
				end
		end
	else
		begin
			if @endAt <= '11:00:00'       -- 9h đến 11h
				begin
					set @a = cast((cast(@endAt as datetime) - cast(@startAt as datetime)) as time)
					set @a1 = datepart(hour, @a) + datepart(minute, @a)/60.0
					set @result = @a1*25000
					return @result
				end
		end
	if @startAt < '15:00:00'
		begin
			if @endAt <= '15:00:00'    -- 13h đến 15h
				begin
					set @a = cast((cast(@endAt as datetime) - cast(@startAt as datetime)) as time)
					set @a1 = datepart(hour, @a) + datepart(minute, @a)/60.0
					set @result = @a1*30000
					return @result
				end
			else						-- 13h đến 17h
				begin
					set @a = cast((cast('15:00:00' as datetime) - cast(@startAt as datetime)) as time)
					set @b = cast((cast(@endAt as datetime) - cast('15:00:00' as datetime)) as time)
					declare @d float = datepart(hour, @a) + datepart(minute, @a)/60.0
					declare @d1 float = datepart(hour, @b) + datepart(minute, @b)/60.0
					set @result = @d*30000 + @d1*35000
					return @result
				end
		end
	else
		begin
			if @endAt <= '17:00:00'			-- 15h đến 17h
				begin
					set @a = cast((cast(@endAt as datetime) - cast(@startAt as datetime)) as time)
					set @a1 = datepart(hour, @a) + datepart(minute, @a)/60.0
					set @result = @a1*35000
					return @result
				end
		end
	if @startAt between '19:00:00' and '21:00:00' and @endAt between '19:00:00' and '21:00:00'
		begin
			set @a = cast((cast(@endAt as datetime) - cast(@startAt as datetime)) as time)
			set @a1 = datepart(hour, @a) + datepart(minute, @a)/60.0
			set @result = @a1*40000
		end
	return @result
end
 
-- thực thi
go
select dbo.getMoneyFromHour(GioBD, GioKetThuc) as TotalMoney
FROM ThueSan
where MaThueSan = '09032022001'

-- câu 3 tạo thủ tục
-- a. thêm vào bảng Giá tiền thuê sân có kiểm tra khóa chính, giờ vào phải nhỏ hơn giờ ra
go
create proc addGiaTienThueSan @magt char(10), @startAt time(0), @endAt time(0), @sotien int
as
begin
	if @magt is null 
		print N'Khóa chính không được phép rỗng, vui lòng nhập lại'
	else if @magt is not null and exists (select MaGT from GiaTienThueSan where MaGT = @magt)
		print N'Khóa chính đã tồn tại, vui lòng nhập lại'
	else if @startAt > @endAt
		print N'Giờ vào phải nhỏ hơn giờ ra'
	else
		insert into GiaTienThueSan values (@magt, @startAt, @endAt, @sotien)
end
go
-- thực thi
exec dbo.addGiaTienThueSan 'GT006', '21:00:00', '23:00:00', 45000
go
drop proc addGiaTienThueSan
go

-- cập nhật dịch vụ thuê áo thêm 10000
create proc updateDVThueAo
as
begin
	update DichVu
	set DonGia += 10000
	where MaDV = 'DV001'
end
go
exec dbo.updateDVThueAo
drop proc updateDVThueAo
go

-- câu 4 tạo trigger khi thêm, xóa, sửa dữ liệu trong bảng chi tiết thuê sân
-- Cập nhật lại Tổng tiền trong bảng thuê sân. Trong đó, tổng tiền = tiền thuê sân + tiền sử dụng dịch vụ của lần thuê sân đó
-- Đơn giá trong bảng Chi tiết thuê sân phải bằng với đơn giá trong bảng dịch vụ
go
create trigger cau4
on ChiTietThueSan	
for insert, update, delete
as
begin
	if (exists (select * from inserted) and not exists (select * from deleted)) -- them
		begin
			--- update thue san
			update ThueSan
			set TongTien = dbo.getMoneyFromHour(GioBD, GioKetThuc)
							+ (select sum(ct.SoLuong * dv.DonGia) from DichVu dv, ChiTietThueSan ct, inserted
													where ct.MaDV = dv.MaDV and ct.MaThueSan = inserted.MaThueSan)
			from ThueSan
			join inserted on ThueSan.MaThueSan = inserted.MaThueSan
			-- update chi tiet thue san
			update ChiTietThueSan
			set DonGia = DichVu.DonGia
			from DichVu, inserted
			where ChiTietThueSan.MaDV = inserted.MaDV
			print N'Đã thêm vào chi tiết thuê san mới'
		end
	else if (not exists (select * from inserted) and exists (select * from deleted)) -- xoa
		begin
			declare @mats char(20) = (select MaThueSan from deleted)
			declare @madv char(10) = (select MaDV from deleted)
			-- update thue san
			update ThueSan
			set TongTien = dbo.getMoneyFromHour(GioBD, GioKetThuc)
							- (select sum(ct.SoLuong * dv.DonGia) from DichVu dv, ChiTietThueSan ct, deleted
													where ct.MaDV = dv.MaDV and ct.MaThueSan = deleted.MaThueSan)
			from ThueSan
			join deleted on ThueSan.MaThueSan = deleted.MaThueSan
		end
	else -- sửa
		begin
			declare @mts_new char(20) = (select MaThueSan from inserted)
			declare @madv_new char(10) = (select MaDV from inserted)
			declare @sl_new int = (select SoLuong from inserted)
			declare @mts_old char(20) = (select MaThueSan from deleted)
			declare @madv_old char(10) = (select MaDV from deleted)
			declare @sl_old int = (select SoLuong from deleted)

			if update(MaThueSan) or update(MaDV) or update(SoLuong)
				begin
					update ChiTietThueSan
					set MaThueSan = @mts_new, MaDV = @madv_new, SoLuong = @sl_new
					where MaThueSan = @madv_old and MaDV = @madv_old and SoLuong = @sl_old

					--- update thue san
					update ThueSan
					set TongTien = dbo.getMoneyFromHour(GioBD, GioKetThuc)
									+ (select sum(@sl_new * dv.DonGia) from DichVu dv, ChiTietThueSan ct
										where @madv_new = dv.MaDV and ct.MaThueSan = @mts_new)
					from ThueSan
					join inserted on ThueSan.MaThueSan = inserted.MaThueSan

					-- update chi tiet thue san
					update ChiTietThueSan
					set DonGia = DichVu.DonGia
					from DichVu
					where DichVu.MaDV = @madv_new and MaThueSan = @mts_new and ChiTietThueSan.MaDV = @madv_new
				end
		end
end
go

insert into ChiTietThueSan values('09032022001', 'DV001', 5, 200000)
delete from ChiTietThueSan where MaDV = 'DV001' and MaThueSan = '09032022001'
update ChiTietThueSan
set SoLuong = 4, MaDV = 'DV003'
where MaThueSan = '09032022001'