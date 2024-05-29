const makeEntityMatrix = (entity) => {
  const [f, r, u, a] = GetEntityMatrix(entity);

  return new Float32Array([
    r[0],
    r[1],
    r[2],
    0,
    f[0],
    f[1],
    f[2],
    0,
    u[0],
    u[1],
    u[2],
    0,
    a[0],
    a[1],
    a[2],
    1,
  ]);
};

const applyEntityMatrix = (entity, mat) => {
  SetEntityMatrix(
    entity,
    mat[4],
    mat[5],
    mat[6], // right
    mat[0],
    mat[1],
    mat[2], // forward
    mat[8],
    mat[9],
    mat[10], // up
    mat[12],
    mat[13],
    mat[14] // at
  );
};

let stupidMatrix = null;

exports("prepareGizmo", (entity) => {
  stupidMatrix = makeEntityMatrix(entity);
});

exports("drawGizmo", (entity) => {
  const changed = DrawGizmo(stupidMatrix, "Editor1");
  if (changed) {
    // Apply the changes from the buff
    applyEntityMatrix(entity, stupidMatrix);
  }
});

RegisterKeyMapping(
  "+gizmoSelect",
  "Objects - Drag (Leave as Left Mouse)",
  "MOUSE_BUTTON",
  "MOUSE_LEFT"
);
RegisterKeyMapping(
  "+gizmoTranslation",
  "Objects - Translation Mode",
  "keyboard",
  "Q"
);
RegisterKeyMapping(
  "+gizmoRotation",
  "Objects - Rotation Mode",
  "keyboard",
  "R"
);
RegisterKeyMapping(
  "+gizmoCameraToggle",
  "Objects - Toggle Camera",
  "keyboard",
  "C"
);
// RegisterKeyMapping(
//   "+gizmoScale",
//   "Objects - Scale Mode",
//   "keyboard",
//   "S"
// );
