import React from "react";
import { Navigate, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "./useAuth";

const DEFAULT_POLICY = {
  mode: "public",
  redirects: {},
};

function toArray(value) {
  return Array.isArray(value) ? value : [];
}

function hasAny(authorities, roles) {
  const allowedRoles = toArray(roles);
  if (allowedRoles.length === 0) return true;
  return allowedRoles.some((role) => authorities.includes(role));
}

function isBlocked(authorities, roles) {
  return toArray(roles).some((role) => authorities.includes(role));
}

function decideAccess({ status, isAuthed, authorities }, policy, locationPath) {
  if (status === "loading") return { type: "loading" };

  const resolvedPolicy = { ...DEFAULT_POLICY, ...policy };
  const redirects = resolvedPolicy.redirects ?? {};
  const unauthedTo = redirects.unauthed ?? "/login";
  const forbiddenTo = redirects.forbidden ?? "/403";
  const authedTo = redirects.authed ?? "/";

  if (resolvedPolicy.mode === "guest") {
    if (isAuthed) return { type: "redirect", to: authedTo };
    return { type: "allow" };
  }

  if (resolvedPolicy.mode === "auth") {
    if (!isAuthed) {
      return { type: "redirect", to: unauthedTo, state: { from: locationPath } };
    }

    if (!hasAny(authorities, resolvedPolicy.allow)) {
      return { type: "redirect", to: forbiddenTo };
    }

    return { type: "allow" };
  }

  if (resolvedPolicy.mode === "public") {
    if (isAuthed && isBlocked(authorities, resolvedPolicy.block)) {
      return { type: "redirect", to: forbiddenTo };
    }

    return { type: "allow" };
  }

  return { type: "allow" };
}

export default function Guard({ policy, children }) {
  const auth = useAuth();
  const location = useLocation();

  const decision = decideAccess(auth, policy, location.pathname);

  if (decision.type === "loading") return null;

  if (decision.type === "redirect") {
    return <Navigate to={decision.to} replace state={decision.state} />;
  }

  return children ?? <Outlet />;
}
