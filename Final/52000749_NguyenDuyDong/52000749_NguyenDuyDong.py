from itertools import combinations

def KTBaoDong(attr, PTH):
	closure = set(attr)
	last = set()
	while closure != last:
		last = closure.copy()
		for dep in PTH:
			if dep[0].issubset(closure):
				closure.update(dep[1])
	return closure

def timKhoa(LDQH, PTH):
	result = []
	for i in range(1, len(LDQH)+1):
		for keys in combinations(LDQH, i):
			if KTBaoDong(keys, PTH) == LDQH:
				k = set(keys)
				if not any([x.issubset(k) for x in result]):
					result.append(k)
	return result

def unique_list(l_2d):
    check = []
    return [x for x in l_2d if x not in check and not check.append(x)]

def phuToiThieu(PTH):
	G = []
	#phan ra cac thuoc tinh ben ve phai
	for dep in PTH:
		if len(dep[1]) == 1:
			G.append((set(dep[0]), set(dep[1])))
			continue
		for e in dep[1]:
			G.append((set(dep[0]), set(e)))
	#loai bo thuoc tinh du thua ve trai
	for dep in G:
		save = []
		if len(dep[0]) > 1:
			for e in dep[0]:
				temp = G.copy()
				tempSet = [(set(e), dep[1])]
				if tempSet in G:
					temp.remove(tempSet)
				if dep[1].issubset(KTBaoDong(e, temp)) is False:
					save.append(e)
		if len(save) != len(dep[0]):
			for x in save:
				dep[0].discard(x)
	G = unique_list(G)
	# loai bo phu thuoc ham du thua
	GTemp = G.copy()
	for dep in G:
		attr = tuple(dep[0])
		temp = G.copy()
		temp.remove(dep)
		if dep[1].issubset(KTBaoDong(attr, temp)):
			GTemp.remove(dep)
	G = GTemp
	return G

def ktDangChuan2NF(PTH, keys, notKeys):
	# X -> A
	print('------------------ Kiem tra 2NF----------------------')
	for dep in PTH:
		print('Kiem tra', ''.join(dep[0]), ' -> ', ''.join(dep[1]))
		if dep[0] in keys:  #T.hop A thuoc X hoac X la sieu khoa
			print(''.join(dep[0]), 'la sieu khoa')
			continue
		if len(dep[0] & notKeys):
			print('co thuoc tinh khong khoa', ''.join(dep[0] & notKeys), 'thuoc', ''.join(dep[0]))
			continue
		for attr in notKeys:
			if attr in dep[1]:	# A khong la thuoc tinh khoa trong R
				print(attr, 'Khong la thuoc tinh nguyen to')
				print('LDQH khong dat 2NF')
				return False
	return True

def ktDangChuan3NF(PTH, keys, notKeys):
	# X -> Y. Dat dang chuan 3 khi :
	# X la sieu khoa
	# Y la thuoc tinh nguyen to
	print('------------------ Kiem tra 3NF----------------------')
	for dep in PTH:
		print('Kiem tra', ''.join(dep[0]), ' -> ', ''.join(dep[1]))
		if dep[0] in keys:				# X la sieu khoa
			print(dep[0], 'la sieu khoa')
			continue
		for attr in notKeys:
			if attr in dep[1]:			# Y la thuoc tinh nguyen to
				print(attr, 'Khong phai la thuoc tinh nguyen to')
				print('LDQH khong dat 3NF')
				return False
	return True

def ktDangChuanBCNF(PTH, keys):
	print('------------------ Kiem tra BCNF----------------------')
	for dep in PTH:
		print('Kiem tra', ''.join(dep[0]), ' -> ', ''.join(dep[1]))
		if dep[0] not in keys:
			print(''.join(dep[0]), 'khong la sieu khoa')
			print('LDQH khong dat BCNF')
			return False
	return True

if __name__ == '__main__':
	LDQH = {'M', 'N', 'O', 'P', 'R', 'Q', 'S'}
	PTH = [({'S'}, {'R', 'M'}),
			({'N', 'S'}, {'Q', 'M'}),
			({'P', 'Q'}, {'R', 'S'}),
			({'O', 'M'}, {'R', 'N'}),
			({'N'}, {'R'})]

	#PTH1 = [({'A', 'B'}, {'D'}),
	#		({'B'}, {'C'}),
	#		({'A', 'E'}, {'B'}),
	#		({'A'}, {'D'}),
	#		({'D'}, {'E', 'F'})]
	LDQH2 = {'S', 'I', 'D', 'M'}
	PTH2 = [({'S', 'I'}, {'D', 'M'}),
			({'S', 'D'}, {'M'}),
			({'D'}, {'M'})]

	print('Khoa cua LDQH: ', timKhoa(LDQH, PTH))
	print('Phu toi thieu cua luoc do quan he: ')
	G = phuToiThieu(PTH)
	for dep in G:
		print(''.join(dep[0]), ' -> ', ''.join(dep[1]))
	x = set()
	keys = timKhoa(LDQH, PTH)
	for i in keys:
		x = x.union(i)
	print('Thuoc tinh nguyen to: ', x)
	temp = LDQH.copy()
	for i in x:
		temp.remove(i)
	print('Thuoc tinh khong khoa: ', temp)
	check2NF = False
	check3NF = False
	checkBCNF = False
	if ktDangChuan2NF(PTH, timKhoa(LDQH, PTH), temp):
		check2NF = True
	if ktDangChuan3NF(PTH, timKhoa(LDQH, PTH), temp):
		check3NF = True
	if ktDangChuanBCNF(PTH, timKhoa(LDQH, PTH)):
		checkBCNF = True
	print('------------------Ket Luan----------------------')
	if checkBCNF:
		print('Vạy luoc do quan he dat chuan BCNF')
	elif check3NF:
		print('Vay luoc do quan he dat chuan 3NF')
	elif check2NF:
		print('Vay luoc do quan he dat chuan 2NF')
	else:
		print('Vay luoc do quan he dat chuan 1NF')

