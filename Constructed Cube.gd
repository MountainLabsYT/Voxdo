extends Node3D
var VOXEL_SIZE = 0.025
var S = VOXEL_SIZE
var SN = VOXEL_SIZE * -1

var mat = preload("res://Materials/WhiteMat.tres")
var pink = preload("res://Materials/PinkMat.tres")


func _ready():

	
	# Create an instance of SurfaceTool
	var st = SurfaceTool.new()

	# Begin drawing a new surface
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(mat)
	
	# Define vertices for the cube
	var vertices = [
		Vector3(SN, S, S),  # 0
		Vector3(S, S, S),   # 1
		Vector3(S, SN, S),  # 2
		Vector3(SN, SN, S), # 3
		Vector3(SN, S, SN), # 4
		Vector3(S, S, SN),  # 5
		Vector3(S, SN, SN), # 6
		Vector3(SN, SN, SN) # 7
	]
	
	# Define the faces of the cube (each face is made up of two triangles)
	var faces = [
		# Front face
		0, 1, 2,  0, 2, 3,
		# Back face
		5, 4, 7,  5, 7, 6,
		# Top face
		4, 5, 1,  4, 1, 0,
		# Bottom face
		3, 2, 6,  3, 6, 7,
		# Left face
		4, 0, 3,  4, 3, 7,
		# Right face
		1, 5, 6,  1, 6, 2
	]
	
	# Add vertices to the SurfaceTool
	for i in faces:
		st.add_vertex(vertices[i])
	# Commit the vertex data to create the mesh
	var mesh = st.commit()
	
	# Create a MeshInstance to display the mesh
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	
	
	
	
	# Add the MeshInstance to the current node
	add_child(mesh_instance)

