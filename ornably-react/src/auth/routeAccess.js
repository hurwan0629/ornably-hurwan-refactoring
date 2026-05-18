export const ACCESS = {
  PUBLIC_BLOCK_ONBOARD: {
    mode: "public",
    block: ["ONBOARD"],
    redirects: { forbidden: "/onboard" },
  },

  GUEST_ONLY: {
    mode: "guest",
    redirects: { authed: "/" },
  },

  ONBOARD_ONLY: {
    mode: "auth",
    allow: ["ONBOARD"],
    redirects: { unauthed: "/login", forbidden: "/403" },
  },

  USER_ONLY: {
    mode: "auth",
    allow: ["USER"],
    redirects: { unauthed: "/login", forbidden: "/403" },
  },

  ADMIN_ONLY: {
    mode: "auth",
    allow: ["ADMIN"],
    redirects: { unauthed: "/admin/login", forbidden: "/403" },
  },
};
