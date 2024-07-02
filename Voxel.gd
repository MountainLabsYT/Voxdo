extends Node

var mesh = preload("res://Mesh.res")
var quad_mesh = preload("res://Quad_Mesh.tres")

var white = preload("res://Materials/WhiteMat.tres")
var pink = preload("res://Materials/PinkMat.tres")
var brown = preload("res://Materials/Brown.tres")

var grid_size_num = 100

const VOXEL_SIZE = 0.12  # Size of each voxel
var S = VOXEL_SIZE / 2
var SN = VOXEL_SIZE * -1 / 2
var grid_size = Vector3i(grid_size_num, 60, grid_size_num)  # Size of the voxel grid
var voxel_array = []  # 1D array to store voxel values

func _ready():
	initialize_voxel_array2()
	render_voxels()

func initialize_voxel_array():
	var total_voxels = int(grid_size.x * grid_size.y * grid_size.z)
	voxel_array.resize(total_voxels)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(total_voxels):
		voxel_array[i] = randi_range(0, 3)  # Randomize voxel values (0 or 2)
		
func initialize_voxel_array2():
	var total_voxels = int(grid_size.x * grid_size.y * grid_size.z)
	voxel_array.resize(total_voxels)
	var rng = RandomNumberGenerator.new()
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.01
	
	var biome_noise = FastNoiseLite.new()
	biome_noise.frequency = 0.01
	
	for i in range(total_voxels):
		voxel_array[i] = 0
	
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			for z in range(grid_size.z):
				var index = int(x + y * grid_size.x + z * grid_size.x * grid_size.y)
				if index >= 0 and index < voxel_array.size():  # Safety check
					if round(noise.get_noise_2d((x * VOXEL_SIZE) + self.position.x, (z * VOXEL_SIZE) + self.position.z) * 200) + 30 == y:
						voxel_array[index] = randi_range(1,2)
					else:
						if round(noise.get_noise_2d((x * VOXEL_SIZE) + self.position.x, (z * VOXEL_SIZE) + self.position.z) * 200) + 30 > y:
							voxel_array[index] = 3
func render_voxels():
	# Clear previous voxel meshes
	for child in get_children():
		if child is MeshInstance3D:
			child.queue_free()




# create a precreated cube mesh, for face culling and color



	

	
	
	
	

# set cube mesh to our precreated cube mesh.

	
	var pinkvox = 0
	var greenvox = 0
	var voxel_count = 0
	var brownvox = 0
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			for z in range(grid_size.z):
				var index = int(x + y * grid_size.x + z * grid_size.x * grid_size.y)
				if index >= 0 and index < voxel_array.size():  # Safety check
					if not voxel_array[index] == 0:
						#get non-air voxels.
						voxel_count += 1
						if voxel_array[index] == 1:
							greenvox += 1
						if voxel_array[index] == 2:
							pinkvox += 1
						if voxel_array[index] == 3:
							brownvox += 1
				else:
					print("Invalid index:", index)
	print("there are: ", voxel_count, " voxels.")
	print("there are: ", pinkvox, " pink voxels.")
	print("there are: ", greenvox, " white voxels.")
	print("there are: ", brownvox, " brown voxels.")
	
	
	
	
	
	#setting up totalmesh, the actual mesh.
	var totalmesh = ArrayMesh.new()

	
	
	
	#Create an Array for the different voxel data types.
	var surface1 = []
	var surface2 = []
	var surface3 = []
	
	
	#creating surface tool
	var st = SurfaceTool.new()
	st.set_smooth_group(0)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(1)
	
	
	
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			for z in range(grid_size.z):
				var index = int(x + y * grid_size.x + z * grid_size.x * grid_size.y)
				if index >= 0 and index < voxel_array.size():  # Safety check
					
					var faces_to_do = [true, true, true, true, true, true]
					if int((x + 1) + (y + 1) * grid_size.x + (z + 1) * grid_size.x * grid_size.y) >= 0 and int((x + 1) + (y + 1) * grid_size.x + (z + 1) * grid_size.x * grid_size.y) < voxel_array.size() and int((x - 1) + (y - 1) * grid_size.x + (z - 1) * grid_size.x * grid_size.y) >= 0 and int((x - 1) + (y - 1) * grid_size.x + (z - 1) * grid_size.x * grid_size.y) < voxel_array.size():
						
						if not voxel_array[int((x + 1) + y * grid_size.x + z * grid_size.x * grid_size.y)] == 0:
							faces_to_do[0] = false
						if not voxel_array[int((x - 1) + y * grid_size.x + z * grid_size.x * grid_size.y)] == 0:
							faces_to_do[1] = false
						if not voxel_array[int(x + (y + 1) * grid_size.x + z * grid_size.x * grid_size.y)] == 0:
							faces_to_do[2] = false
						if not voxel_array[int(x + (y - 1) * grid_size.x + z * grid_size.x * grid_size.y)] == 0:
							faces_to_do[3] = false
						if not voxel_array[int(x + y * grid_size.x + (z + 1) * grid_size.x * grid_size.y)] == 0:
							faces_to_do[4] = false
						if not voxel_array[int(x + y * grid_size.x + (z - 1) * grid_size.x * grid_size.y)] == 0:
							faces_to_do[5] = false
						
					
					#print(faces_to_do)
					var transform = Transform3D()
					transform.origin = Vector3((x * VOXEL_SIZE), (y * VOXEL_SIZE), (z * VOXEL_SIZE))
					
					if not faces_to_do == [false, false, false, false, false, false]	:
						if voxel_array[index] == 1:
							surface1.append(create_voxel(st, transform.origin, voxel_array, totalmesh, faces_to_do))
							
						if voxel_array[index] == 2:
							surface2.append(create_voxel(st, transform.origin, voxel_array, totalmesh, faces_to_do))
							
						if voxel_array[index] == 3:
							surface3.append(create_voxel(st, transform.origin, voxel_array, totalmesh, faces_to_do))


				else:
					print("Invalid index:", index)
	
	
	st.commit(totalmesh)
	
	st.set_material(white)
	for i in surface1.size():
		for b in surface1[i].size():
			st.add_vertex(surface1[i][b])
	st.commit(totalmesh)
	
	st.set_material(pink)
	for i in surface2.size():
		for b in surface2[i].size():
			st.add_vertex(surface2[i][b])
	st.commit(totalmesh)
	
	st.set_material(brown)
	for i in surface3.size():
		for b in surface3[i].size():
			st.add_vertex(surface3[i][b])
	st.commit(totalmesh)
	
	#st.create_from(surface1holder, 0)
	#st.set_material(white)
	#st.commit(totalmesh)
	
	#st.create_from(surface2holder, 0)
	#st.set_material(pink)
	#st.commit(totalmesh)
	
	
	var ChunkMesh = MeshInstance3D.new()
	ChunkMesh.mesh = totalmesh
	add_child(ChunkMesh)










func create_voxel(st, offset, voxels, totalmesh, faces_to_gen):

	var arraylist = []
	
	# Begin drawing a new surface
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Define vertices for the cube
	var vertices = [
		Vector3(SN + offset.x, S + offset.y, S + offset.z),  # 0
		Vector3(S + offset.x, S + offset.y, S + offset.z),   # 1
		Vector3(S + offset.x, SN + offset.y, S + offset.z),  # 2
		Vector3(SN + offset.x, SN + offset.y, S + offset.z), # 3
		Vector3(SN + offset.x, S + offset.y, SN + offset.z), # 4
		Vector3(S + offset.x, S + offset.y, SN + offset.z),  # 5
		Vector3(S + offset.x, SN + offset.y, SN + offset.z), # 6
		Vector3(SN + offset.x, SN + offset.y, SN + offset.z) # 7
	]
	
	# Define the faces of the cube (each face is made up of two triangles)
	var faces = []
	
	var front_face = [0, 1, 2,  0, 2, 3,]
	var back_face = [5, 4, 7,  5, 7, 6,]
	var top_face = [4, 5, 1,  4, 1, 0,]
	var bottom_face = [3, 2, 6,  3, 6, 7,]
	var left_face = [4, 0, 3,  4, 3, 7,]
	var right_face = [1, 5, 6,  1, 6, 2]
	
	if faces_to_gen[0] == true:
		faces += right_face
		pass
	if faces_to_gen[1] == true:
		faces += left_face
		pass
	if faces_to_gen[2] == true:
		faces += top_face
		pass
	if faces_to_gen[3] == true:
		faces += bottom_face
		pass
	if faces_to_gen[4] == true:
		faces += front_face
		pass
	if faces_to_gen[5] == true:
		faces += back_face
		pass

	
	# Add vertices to the SurfaceTool
	for i in faces:
		arraylist.append(vertices[i])
	
	# Commit the vertex data to create the mesh
	return arraylist
	print(arraylist)


	


